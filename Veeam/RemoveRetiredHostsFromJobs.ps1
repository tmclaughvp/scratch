

### Includes ###
Add-PSSnapin "VMware.VimAutomation.Core" -ErrorAction SilentlyContinue
Add-PSSnapin "VeeamPSSnapIn" -ErrorAction SilentlyContinue

### Variables ###
$vCenterList = @('vcenter101.vistaprint.net', 'vcenter301.vistaprint.net', 'vcenter701.vistaprint.net', 'vcenter801.vistaprint.net')
$mailFrom = 'noreply@vistaprint.com'
$mailTo = 'tmclaughlin@vistaprint.com'
$mailRelay = 'relay.vistaprint.net'

### Functions ###
function getJobDC {
	param ($jobName)
	
	process{
		return $jobName.Substring(0,3)
	}
}

### Run ###
## Connect to each vcenter and generate a list of all VMs.
$vMNameList = @()

foreach ($_vc in $vCenterList) {
	$vc = Connect-VIServer -Server $_vc
	$vMs = get-vm
	foreach ($_vm in $vMs) {
		$vMNameList += $_vm.Name
	}
	Disconnect-VIServer -Server $_vc -Confirm:$false
}

## Loop through jobs and remove
$removedVms = @()
$jobs = @(get-VBRJob)
foreach ($_job in $jobs) {
	$jobObjs = get-vbrJobObject -Job $_job
	foreach ($_jo in $jobObjs) {
		if ($vMNameList -notcontains $_jo.Name) {
			$removedVms += $_jo.Name
			$_jo.Delete()
		}
	}
}

if ($removedVms.Count -gt 0) {
	$body = "The following VMs are no longer present and have been removed from the`r`nappropriate backup jobs.`r`n"
	
	foreach ($_vm in $removedVms | Sort-Object) {
		$body += "${_vm}`r`n"
	}
	
	Send-MailMessage -to $mailTo -from $mailFrom -SmtpServer $mailRelay -Subject "Veeam: Hosts removed." -Body $body
}