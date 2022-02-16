$rgname = "prod-westus"
$vmssname = "test-vmss"
$Id = 1
$location = "West US"

$vmss1 = Get-AzVmssVM -ResourceGroupName $rgname -VMScaleSetName $vmssname -InstanceId $Id     

$snapshotconfig = New-AzSnapshotConfig -Location $location -AccountType Standard_LRS -OsType Linux -CreateOption Copy -SourceUri $vmss1.StorageProfile.OsDisk.ManagedDisk.id

New-AzSnapshot -ResourceGroupName $rgname -SnapshotName 'mySnapshot' -Snapshot $snapshotconfig
