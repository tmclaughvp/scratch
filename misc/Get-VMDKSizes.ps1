#
# Get-VMDiskUsage
#
#
# Get-VMDiskUsage -

param (
	$vcenter = 'vcenter101.vistaprint.net',
	$datacenter = 'lexington',
	$glob = 'dev*101',
	$device = '0:0'
)

### Includes ###
Add-PSSnapin "VMware.VimAutomation.Core" -ErrorAction SilentlyContinue
Add-PSSnapin "VeeamPSSnapIn" -ErrorAction SilentlyContinue

### Variables ###
[int]$busNum, [int]$devNum = $device.split(':')
$SCSILABEL = 'SCSI Controller'

### Functions ###
function Get-VMDKFilesByDS {
	param ($ds)
	
	process {
		
		$dsView = $ds | Get-View

		$fileQueryFlags = New-Object VMware.Vim.FileQueryFlags
		$fileQueryFlags.FileSize = $true
		$fileQueryFlags.FileType = $true
		$fileQueryFlags.Modification = $true

		$searchSpec = New-Object VMware.Vim.HostDatastoreBrowserSearchSpec
		$searchSpec.details = $fileQueryFlags
		$searchSpec.sortFoldersFirst = $true

		$dsBrowser = Get-View $dsView.browser
		$rootPath = "[{0}]" -f ($dsView.summary.Name)
		$searchResult = $dsBrowser.SearchDatastoreSubFolders($rootPath, $searchSpec)
		
		$folderHash = @{}
		foreach ($result in $searchResult) {
            if ($result.FolderPath.EndsWith('/')){
				Write-Host "`t" $result.FolderPath
				$fileSizeHash = @{}
				
                foreach ($file in $result.File) {
					$fileSizeHash.Add($file.Path, $file.FileSize)
                }
			    
                $folderName = $result.FolderPath.split()[1].TrimEnd('/')
			    $folderHash.Add($folderName, $fileSizeHash)
            }
		}
		
		return $folderHash
	}
}

### Run ###
# Connect to VC
$vc = Connect-VIServer -Server $vcenter

# Get list of VMs and file sizes
$vMS = @()
$vMS = Get-VM -Location $datacenter -name $glob
$datastoreIds = @()

$vmCapacity = 0
$vmFree = 0
$vmHash = @{}
foreach ($_vm in $vMS) {
	
	Write-Host "--------"
	Write-Host $_vm.Name
	$VMView = $_vm | Get-View
	$controllerHash = @{}
	foreach ($sCSIController in ($VMView.Config.Hardware.Device | Where {$_.DeviceInfo.Label -match $SCSILABEL})) {
		Write-Host ("`t{0}:" -f $sCSIController.DeviceInfo.Label)
		$diskHash = @{}
		foreach ($Disk in ($VMView.Config.Hardware.Device | Where {$_.ControllerKey -eq $sCSIController.Key})) {
			if ($datastoreIds -notcontains $disk.Backing.Datastore) {
				$datastoreIds += $disk.Backing.Datastore
			}
			
			Write-Host ("`t`t{0}" -f $disk.Backing.FileName)
			$diskHash.Add($disk.UnitNumber, $disk.Backing.FileName)
			$vmCapacity += $Disk.CapacityInKB
		}
		$controllerHash.Add($sCSIController.BusNumber, $diskHash)
	}
	
	$vmHash.Add($_vm.Name, $controllerHash)
}

Write-Host ("Capacity (thick) size: {0}KB" -f $vmCapacity)

$dsHier = @{}
Write-Host "Querying datastores (this will take a while):"
foreach ($dsId in $datastoreIds) {
	$ds = Get-Datastore -Id $dsId
	Write-Host $ds.Name
	$files = Get-VMDKFilesByDS -ds $ds
	$dsHier.add($ds.Name, $files)
}

$totalSize = 0
foreach ($_vmName in $vmHash.keys) {
	$dsPath = $vmHash.get_Item($_vmName).get_Item($busNum).Get_Item($devNum)
	#'[DEV_lun23lex] devvimage101/devvimage101.vmdk' => [DEV_lun23lex]', 'devvimage101/devvimage101.vmdk
	$dsName, $filepath = $dsPath.split()
	$dsName = $dsName.Trim('[]')
	$fileDir, $fileName = $filepath.Split('/')
	
	$diskSize = $dsHier.get_Item($dsName).Get_Item($fileDir).Get_Item($fileName)
	$totalSize += $diskSize
}

Write-Host ("Total size: {0}B" -f $totalSize)
$totalSizeInGB = $totalSize/1GB
Write-Host ("Total size: {0}GB" -f $totalSizeInGB)
$totalSizeInTB = $totalSize/1TB
Write-Host ("Total size: {0}TB" -f $totalSizeInTB)

Disconnect-VIServer -Server $vcenter -Confirm:$false
