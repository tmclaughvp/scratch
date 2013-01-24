# Report-VeeamNeedsDiskExclusion

param ($MailTo = 'tmclaughlin@vistaprint.net',
		$ExclusionFile = 'C:\Program Files\Veeam\disk-report-exclusions.txt')

Add-PSSnapin "VeeamPSSnapIn" -ErrorAction SilentlyContinue

$mailRelay = 'relay.vistaprint.net'
$mailFrom = 'noreply@vistaprint.net'
$DISK0 = '2000' # Veeam numbers disks in its filter from 2000-2063.

function Get-Exclusions
{
	param ($fileName)
	process {
		$fileContent = Get-Content $fileName -ErrorAction SilentlyContinue
			if ($fileContent) {
			$exclusionsList = @()
			foreach ($_l in $fileContent) {
				if (! $_l.startsWith($COMMENT)) {
					$exclusionsList += $_l
				}
			}
			return $exclusionsList
		}
	}
}

$exclusionsList = Get-Exclusions $ExclusionFile
# Get list of all VM names currently being backed up.
# Always return an array.  You're a stupid language PowerShell...
$BackupJobs = @(Get-VBRJob)
$BackedUpVMs = @()
$needsExclusionHash = @{}
foreach ($_j in $BackupJobs) {
	$objs = $_j.GetObjectsInJob()
	
	$vMsWithoutExclusions= @()
	foreach ($_o in $objs) {
		if ($exclusionsList -notcontains $_o.Name -and $_o.DiskFilter -ne $DISK0) {
			$vMsWithoutExclusions += $_o.Name
		}
	}
	if ($vMsWithoutExclusions.Count -gt 0) {
		$needsExclusionHash.Add($_j.Name, $vMsWithoutExclusions)
	}
}

if ($needsExclusionHash.Count -gt 0) {
	$body = "The following VMs require disk exclusions to be set for them.`r`n"
	
	foreach ($_j in $needsExclusionHash.keys | Sort-Object) {
		$body += "${_j}`r`n"
		foreach ($_vm in $needsExclusionHash.Get_Item($_j)) {
			$body += "`t${_vm}`r`n"
		}
		$body += "`r`n"
	}

	Write-Host $body
	Send-MailMessage -to $mailTo -from $mailFrom -SmtpServer $mailRelay -Subject "Veeam: Hosts requiring disk exclusion." -Body $body
}