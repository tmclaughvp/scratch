#
#
#
# Tom McLaughlin <tmclaughlin@vistaprint.net>, 1/16/2013
#
# AddVmToBackup -VCenter <hostname> -Datacenter <string> -VPEnv <name> -HostGlob <string> -JobPrefix <string> -JobMaxVMs <int>

param (
	$VCenter = 'vcenter101.vistaprint.net',
	$Datacenter = 'lexington',
	$VpEnv = 'dev',
	$HostGlob = 'dev*101',
	$JobPrefix = 'DEV Monthly',
	[int]$JobMaxVMs = 100,
	$ExclusionFile = 'C:\Program Files\Veeam\exclusions.txt'
)

### Includes ###
Add-PSSnapin "VMware.VimAutomation.Core"
Add-PSSnapin "VeeamPSSnapIn"

### Variables ###
$COMMENT = '#'
$mailRelay = 'relay.vistaprint.net'
$mailFrom = 'noreply@vistaprint.net'
$mailTo = 'tmclaughlin@vistaprint.net'

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
	param ($JobObj, $VmObj)
	process {
		$server = Get-VBRServer -Name $VmObj.VMHost.Name
		$JobObjs = Add-VBRJobObject -Job $jobObj -Server $server -Objects $VmObj.Name
		return $JobObjs
	}
}

function GetExclusions
{
	param ($fileName)
	process {
		$fileContent = Get-Content $fileName
		$exclusionsList = @()
		foreach ($_l in $fileContent) {
			if (! $_l.startsWith($COMMENT)) {
				$exclusionsList += $_l
			}
		}
		
		return $exclusionsList
	}
}

function GetVBRJob
{
	param ()
	process {
		$jobName = $JobPrefix + ' - 1'
		return get-VBRJob -Name $jobName
	}
}

### Main ###
$vc = Connect-VIServer -Server $VCenter
$dc = Get-Datacenter -Name $Datacenter
# Debug to make this run quicker.
#$dc = Get-VMHost -Name 'vpesx101.vistaprint.net'

# Get list of all VM names currently being backed up.
$BackedUpVMs = @()
# Always return an array.  You're a stupid language PowerShell...
$BackupJobs = @(Get-VBRJob -name $HostGlob)
foreach ($_j in $BackupJobs) {
	$objs = $_j.GetObjectsInJob()
	foreach ($_o in $objs) {
		$BackedUpVMs += $_o.Name
	}
}

$vms = Get-VM -Name $HostGlob -Location $dc
$exclusionsList = GetExclusions $ExclusionFile
$VMsToAdd = @()
foreach ($_vm in $vms) {
	if ($BackedUpVMs -notcontains $_vm.Name -and $ExclusionsList -notcontains $_vm.Name) {
		$VMsToAdd += $_vm
	}
}

$jobObj = getVBRJob
foreach ($_vmToAdd in $VMsToAdd) {
	$jobObjs = AddVMToJob -JobObj $jobObj -VmObj $_vmToAdd
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
	$mailMsg
	
	Send-MailMessage -to $mailTo -from $mailFrom -subject "Veeam: new $($VpEnv) VMs added in $($Datacenter)" -SmtpServer $mailRelay -Body $MailMsg
}