using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)



# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."


$StorageAccountName = "4besservice"
$StorageAccountResourceGroup = "4besDay8"

$status = $Request.Query.Status
$date = Get-date

$StatusObject = @{
    status     = $status
    UpdateDate = $date
}
$StatusObject | ConvertTo-Json | Out-File "D:\home\data\TempIn.json"
$StorageAccountKey = Get-AzStorageAccountKey -ResourceGroupName $StorageAccountResourceGroup -Name $StorageAccountName

$Context = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey[0].value -ErrorAction Stop
Set-AzStorageFileContent -ShareName 'status' -Source "D:\home\data\TempIn.json" -path 'status.json' -Context $Context -Force


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = [HttpStatusCode]::OK
        ContentType = "application/json"
        Body        = ($StatusObject | ConvertTo-Json )
    })
