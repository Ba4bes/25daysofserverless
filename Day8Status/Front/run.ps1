using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."


#variabelen vastleggen
$StorageAccountName = "4besservice"
$StorageAccountResourceGroup = "4besDay8"

# Haal de key voor het storage-account op
$StorageAccountKey = Get-AzStorageAccountKey -ResourceGroupName $StorageAccountResourceGroup -Name $StorageAccountName

$Context = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey[0].value -ErrorAction Stop

$Content = Get-AzStorageFileContent -ShareName 'status' -Context $Context -path 'status.json' -Destination "D:\home\data\TempOut.json" -force -PassThru
$status = (get-Content "D:\home\data\TempOut.json") | ConvertFrom-Json
write-output $content

$HTML = @"
<html>
<head>
<head>
  <meta http-equiv="refresh" content="30">
</head>
</head>
<body>
<h1> Santa's Reindeer Guidance & Delivery System</h1>
Status = $($Status.Status) <br>
Last Statusupdate = $($Status.UpdateDate)<br>
This page reloades every 30 seconds
</body>
</html>
"@

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode  = "OK"
    ContentType = "text/html"
    Body        = $HTML
  })
