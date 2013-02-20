#
# Tom McLaughlin <tmclaughlin@vistaprint.net>, 1/16/2013
#
# AddVmToBackup -VCenter <hostname> -Datacenter <string> -VPEnv <name> -HostGlob <string> -Job <string> -JobMaxVMs <int>
#
# TODO:
# - Delete remnants of job sizing
# - eventlog handling
#   - Useful for determing qwhy script crashed or hung when run as scheduled task.
#
#

param (
	$VCenter = 'vcenter101.vistaprint.net',
	$Datacenter = 'lexington',
	$VpEnv = 'dev',
	$HostGlob = 'dev*101',
	$Job = 'LEX DEV',
	[int]$JobMaxVMs = 100,
	$ExclusionFile = 'C:\Program Files\Veeam\backup-exclusions.txt',
	[Switch] $prod = $false
)

### Includes ###
Add-PSSnapin "VMware.VimAutomation.Core" -ErrorAction SilentlyContinue
Add-PSSnapin "VeeamPSSnapIn" -ErrorAction SilentlyContinue

### Variables ###
$COMMENT = '#'
$mailRelay = 'relay.vistaprint.net'
$mailFrom = 'noreply@vistaprint.net'
$mailTo = 'tmclaughlin@vistaprint.net'
$envPrefixes = @('dev', 'tst', 'lod', 'ppd')

# Lowercase our Datacentername
$Datacenter = $Datacenter.ToLower()

$DCBackUpRepo = @{'lexington' = 'dd101';
				  'bermuda' = 'dd01'}
$DCProxyServer = @{'lexington' = 'This server';
				   'bermuda' = 'veeamproxy01.vistaprint.net'}

### Functions ###

function AddVMToJob
{
	#param ([CBackupJob]$JobObj, [VirtualMachineImpl]$VmObj)
	param ($Job, $Vm)
	process {
		$server = Get-VBRServer -Name $Vm.VMHost.Name
		$JobObjs = Add-VBRJobObject -Job $job -Server $server -Objects $Vm.Name
		return $JobObjs
	}
}

function CopyTemplate {
	param ($JobPrefix)
	process {
		$tmplName = $JobPrefix + ' - TMPL'
		$tmpl = Get-VBRJob -Name $tmplName
		$job = Copy-VBRJob -job $tmpl
		return $job
	}
}

function GetExclusions
{
	param ($fileName)
	process {
		$fileContent = Get-Content $fileName -ErrorAction SilentlyContinue
		$exclusionsList = @()
		if ($fileContent) {
			foreach ($_l in $fileContent) {
				if (! $_l.startsWith($COMMENT)) {
					$exclusionsList += $_l
				}
			}
		}
		return $exclusionsList
	}
}

### Main ###
$vc = Connect-VIServer -Server $VCenter
$dc = Get-Datacenter -Name $Datacenter
# Debug to make this run quicker.
#$dc = Get-VMHost -Name 'vpesx101.vistaprint.net'

# Get list of all VM names currently being backed up.
# Always return an array.  You're a stupid language PowerShell...
$BackupJobs = @(Get-VBRJob -name $Job | Sort-Object -Property Name)
$BackedUpVMs = @()
foreach ($_j in $BackupJobs) {
	$objs = $_j.GetObjectsInJob()
	foreach ($_o in $objs) {
		$BackedUpVMs += $_o.Name
	}
}

$vms = Get-VM -Name $HostGlob -Location $dc
# Handle prod BMs only.
if ($prod) {
	Write-Host "Production VMs only."
	$prodVMs = @()
	
	foreach ($_vm in $vMS) {
		$nonProd = $false
		$name = $_vm.Name.toLower()
		foreach ($_e in $envPrefixes) {
			if ($name.startsWith($_e)){
				$nonProd = $true
				break
			}
		}
		if (!$nonProd) {
			$prodVMs += $_vm
		}
	}
	$vMS = $prodVMs
}

# Exclusions
$exclusionsList = GetExclusions $ExclusionFile
$VMsToAdd = @()
foreach ($_vm in $vms) {
	if ($BackedUpVMs -notcontains $_vm.Name -and $ExclusionsList -notcontains $_vm.Name) {
		$VMsToAdd += $_vm
	}
}

$job = $BackupJobs[-1]
foreach ($_vmToAdd in $VMsToAdd) {
	# If $job.length is greater than max, create a new job!
	#if ($job.length -ge $JobMaxVMs) {	
	#}
	$jobObjs = AddVMToJob -Job $job -Vm $_vmToAdd
	#$jobObj = get-VBRJobObjects -job $ $job -name $_vmToAdd
}

# Add-VBRJobObject returns an array of the objects included in the specified
# job.  It does not return or indicate an error if the opperation was
# unsuccessful for the objects that the opperation attempted to add. We'll
# just take the last returned array and compare it with the list of VMs to add
# and see if anything failed.
$jobObjNames = @()
foreach ($_j in $jobObjs) {
	$jobObjNames += $_j.Name
}

$VMsAdded = @()
$VMsFailedToAdd = @()
foreach ($_vmToAdd in $VMsToAdd) {
	if ($jobObjNames -notcontains $_vmToAdd.Name) {
		$VMsFailedToAdd += $_vmToAdd
	} else {
		$VMsAdded += $_vmToAdd
	}
}

# Create email message.
$MailMsg = ""
$VmsAddedList = @()
foreach ($_vmAdded in $VMsAdded) {
	write-Host $_vmAdded
	$VmsAddedList += "$($_vmAdded.Name)`r`n"
}

if ($VmsAddedList) {
	$VMsAddedMsg = @"
The following VMs have been added to a scheduled backup:
$VmsAddedList
	
"@
	$MailMsg += $VMsAddedMsg
}

$VMsFailedList = @()
foreach ($_vmFailedtoAdd in $VMsFailedToAdd) {
	$VmsFailedList += "$($_vmFailedtoAdd.Name)`r`n"
}

if ($VmsFailedList) {
	$VMsFailedMsg = @"
The following VMs have been added to a scheduled backup:
$VmsAddedList
"@
	$MailMsg += $VMsFailedMsg
}

if ($MailMsg) {
	Send-MailMessage -to $mailTo -from $mailFrom -subject "Veeam: new $($VpEnv) VMs added in $($Datacenter)" -SmtpServer $mailRelay -Body $MailMsg
}

Disconnect-VIServer -Server $VCenter -Confirm:$false
