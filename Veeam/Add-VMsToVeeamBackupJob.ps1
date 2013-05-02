#
# Tom McLaughlin <tmclaughlin@vistaprint.net>, 1/16/2013
#
# AddVmToBackup -VCenter <hostname> -Datacenter <string> -VPEnv <name> -HostGlob <string> -Job <string> [-prod]
#
# TODO:
# - Delete remnants of job sizing
# - eventlog handling
#   - Useful for determing qwhy script crashed or hung when run as scheduled task.
#	- May not be possible due to the scheduled task running at a user level which
#	  cannot create event logs. 
# - Script does not gracefull handle database servers in different environments.
#	DB's start with 'db' in their name and are therefore always considered prod
#	hosts by this script.
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
$mailTo = 'veeamadmins@vistaprint.net'
$envPrefixes = @('dev', 'tst', 'lod', 'ppd')

# Lowercase our Datacentername
$Datacenter = $Datacenter.ToLower()

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

## Debug
$d = Get-Date -Format o
$LogfileName = "${job}.log"
$LogFile = New-Item -Force -Path "${env:userprofile}\${LogFileName}" -Type file

$d | Out-file -Append $LogFile.FullName


### Keep track of new VMs each month
$TrackingFileDate = Get-Date -Format "yyyy-MMMM"
$TrackingFile = "C:\Program Files\Veeam\${TrackingFileDate} New VMs.txt"


echo "### Connect to vcenter $(get-Date -format o) ###" | Out-file -Append $LogFile.FullName
$vc = Connect-VIServer -Server $VCenter
echo "### Get Datacenter $(get-Date -format o) ###" | Out-file -Append $LogFile.FullName
$dc = Get-Datacenter -Name $Datacenter

# Sometimes the request times out.  Bail if it does.
if (!$dc) {
	$MailMsg = "FAILED TO GET DATACENTER! - $(get-Date -format o)"
	Send-MailMessage -to $mailTo -from $mailFrom -subject "Veeam FAILURE: new $($VpEnv) VMs added in $($Datacenter)" -SmtpServer $mailRelay -Body $MailMsg
	exit
}

# Debug to make this run quicker.
#$dc = Get-VMHost -Name 'vpesx101.vistaprint.net'

# Get list of all VM names currently being backed up.
# Always return an array.  You're a stupid language PowerShell...
echo "### Get Veeam B&R Job $(get-Date -format o) ###" | Out-file -Append $LogFile.FullName
$BackupJobs = @(Get-VBRJob -name $Job | Sort-Object -Property Name)

echo "### Get backed up VMs $(get-Date -format o) ###" | Out-file -Append $LogFile.FullName
$BackedUpVMs = @()
foreach ($_j in $BackupJobs) {
	$objs = $_j.GetObjectsInJob()
	foreach ($_o in $objs) {
		$BackedUpVMs += $_o.Name
	}
}
echo "$BackedUpVMs" | Out-file -Append $LogFile.FullName

echo "### Get VMs $(get-Date -format o) ###" | Out-file -Append $LogFile.FullName
$vms = Get-VM -Name $HostGlob -Location $dc
echo "$vms" | Out-file -Append $LogFile.FullName

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
echo "### VMsToAdd $(get-Date -format o) ###" | Out-file -Append $LogFile.FullName
echo "$VMsToAdd" | Out-file -Append $LogFile.FullName

$job = $BackupJobs[-1]
foreach ($_vmToAdd in $VMsToAdd) {
	# If $job.length is greater than max, create a new job!
	#if ($job.length -ge $JobMaxVMs) {	
	#}
	echo "Adding: $_vmToAdd" | Out-file -Append $LogFile.FullName
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

echo  "### VMsAdded $(get-Date -format o) ###" | Out-file -Append $LogFile.FullName
echo "$VMsAdded" | Out-file -Append $LogFile.FullName
echo "### VMsFailedToAdd $(get-Date -format o) ###" | Out-file -Append $LogFile.FullName
echo "$VMsFailedToAdd" | Out-file -Append $LogFile.FullName

# Create email message.
$MailMsg = ""
$VmsAddedList = @()
foreach ($_vmAdded in $VMsAdded) {
	$VmsAddedList += "$($_vmAdded.Name)`r`n"
}

if ($VMsAdded) {
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

if ($VMsFailedToAdd) {
	$VMsFailedMsg = @"
The following VMs failed to be added to a scheduled backup:
$VmsFailedList
"@
	$MailMsg += $VMsFailedMsg
}

if ($VmsAddedList -or $VmsFailedList) {
	Send-MailMessage -to $mailTo -from $mailFrom -subject "Veeam: new $($VpEnv) VMs added in $($Datacenter)" -SmtpServer $mailRelay -Body $MailMsg
	$VmsAddedList >> $TrackingFile
}

Disconnect-VIServer -Server $VCenter -Confirm:$false
