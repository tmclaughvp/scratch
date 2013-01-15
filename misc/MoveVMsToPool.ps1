# Search the listed vcenters for hosts that match a substring and move them
# into a specified resource pool.
#
# TODO
# - Take conmmand line arguments
#
# Tom Mclaughlin <tmclaughlin@vistaprint.com>, 1/15/2013
#

$BACKUP_POOL = 'Backup'
$BACKUP_MATCH = '*01'
$vc_list = "..."

foreach ($vc in $vc_list) {
	Write-Host "Connecting to ${vc}"
	Connect-VIServer -server $vc
	
	$cluster_list = Get-Cluster
	$cluster_list
	
	foreach ($cluster in $cluster_list | Sort-Object) {
		Write-Host "Opperating in ${cluster}"
	
		$vm_list = Get-VM -Name $BACKUP_MATCH -Location $cluster
		$res_pool = Get-ResourcePool -Location $cluster $BACKUP_POOL
		$backup_list = Get-VM -Location $res_pool
	
		foreach ($vm in $vm_list | Sort-Object) {
			if ($backup_list -notcontains $vm.Name) {
				Write-Host "Moving $vm"
				<#
				Move-VM -VM $vm -Destination $res_pool
				#>
				
			}
		}
		Write-Host
	}
	
	Write-Host "Disconnecting ${vc}"
	Disconnect-VIServer -Server $vc -Confirm:$false
	Write-Host
}