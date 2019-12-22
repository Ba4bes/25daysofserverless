using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Get the current universal time in the default string format

$StorageAccountName = "$ENV:StorageAccount"
$StorageAccountResourceGroup = "$ENV:StorageAccountRG"
$FunctionAppID = "$ENV:FunctionAppID"

$storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $StorageAccountResourceGroup -AccountName $StorageAccountName).Value[0]
# Set AzStorageContext
$Context = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $storageAccountKey
$AllKeyVaults = Get-AzKeyVault

foreach ($KeyVault in $AllKeyVaults) {
    # Create the keyvault to restore to
    $NewKeyVault = New-AzKeyVault -Name "$($KeyVault.VaultName)-Restore" -ResourceGroupName $KeyVault.ResourceGroupName -Location 'West Europe'
    Set-AzKeyVaultAccessPolicy -VaultName $NewKeyVault.VaultName -ObjectId $FunctionAppID -PermissionsToKeys create, restore -PermissionsToSecrets set, restore -PermissionsToCertificates Create, restore -PassThru

    # get the last backup from the storage account
    $LastBackup = Get-AzStorageContainer -Context $Context | Sort-Object LastModified -Descending | Select-Object -First 1
    $AllBlobs = $LastBackup | Get-AzStorageBlob

    # go through all files and restore them
    foreach ($Blob in $AllBlobs) {

        $RestoreFile = Get-AzStorageBlobContent -Blob $Blob.Name -Container $LastBackup.Name -Destination "D:\home\data\$($Blob.Name)"
        Restore-AzKeyVaultSecret -VaultName $NewKeyVault.VaultName -InputFile "D:\home\data\$($Blob.Name)"
    }
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = "Restore is done"
})