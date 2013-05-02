# Report the VMs added last month by reading a file.

Add-PSSnapin "VeeamPSSnapIn" -ErrorAction SilentlyContinue

$mailRelay = 'relay.vistaprint.net'
$mailFrom = 'noreply@vistaprint.net'
$mailTo = 'veeamadmins@vistaprint.net'

$lastMonthDate = (get-date).AddMonths(-1).toString("yyyy-MMMM")
$fileList = Get-ChildItem -Recurse -Path "C:\Program Files\Veeam\" -Include "New VMs*${LastMonthDate}.txt"


if ($fileList) {
	$MailMsg = ""
	$VMsAddedMsg = @"
The following VMs were added to a scheduled backup the previous month:
	
"@
	foreach($_file in $fileList) {
		$jobName = $_file.name.Split(' ')[2..3] -join ' '
		$MailMsg += "${jobName}:`r`n"
		$VMs = Get-Content $_file
		foreach($_vm in $vMs) {
			$MailMsg += "`t$_vm`r`n"
		}
		$MailMsg += "`r`n"
	}
	
	Send-MailMessage -to $mailTo -from $mailFrom -subject "Veeam: New VMs $LastMonthDate" -SmtpServer $mailRelay -Body $MailMsg
}