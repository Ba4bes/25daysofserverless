# Input bindings are passed in via param block.
param($Timer)

# Get the current universal time in the default string format
$StorageAccountName = "$ENV:StorageAccount"
$StorageAccountResourceGroup = "$ENV:StorageAccountRG"
$storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $StorageAccountResourceGroup -AccountName $StorageAccountName).Value[0]

# Set AzStorageContext
$Context = New-AzStorageContext -StorageAccountName $StorageAccount -StorageAccountKey $storageAccountKey
# The 'IsPastDue' porperty is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}


# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"
$Date = get-date -Format "yyyyMMddhhmm"
$AllKeyVaults = Get-AzKeyVault
$ContainerName = New-AzStorageContainer -Name $date -Context $context -Permission blob

foreach ($KeyVault in $AllKeyVaults) {
    Try {
    $AllSecrets = Get-AzKeyVaultSecret -VaultName $KeyVault.VaultName -ErrorAction Stop
    }
    Catch{
        Write-Output "Could not reach $($KeyVault.VaultName)"
        Continue
    }
    foreach ($Secret in $AllSecrets) {
        # Save file to temp location
        $BackupFile = Backup-AzKeyVaultSecret -VaultName $KeyVault.VaultName -Name $Secret.Name
        $FileName = ($BackupFile -split "\\")[-1]
        # upload a file
        Set-AzStorageBlobContent -File $BackupFile -Container $ContainerName.CloudBlobContainer.Name -Blob $FileName -Context $context
    }
}

