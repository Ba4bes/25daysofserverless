# Input bindings are passed in via param block.
param($Timer)

$StorageAccountName = "$ENV:StorageAccount"
$StorageAccountResourceGroup = "$ENV:StorageAccountRG"

$storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $StorageAccountResourceGroup -AccountName $StorageAccountName).Value[0]
# Set AzStorageContext
$Context = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $storageAccountKey

$AllContainers = Get-AzStorageContainer -Context $Context
foreach ($Container in $AllContainers) {
    if ($Container.LastModified -lt ((get-date).AddDays(-90)) ) {
        Remove-AzStorageContainer -Name $Container.Name -Context $Context -Force
    }
}