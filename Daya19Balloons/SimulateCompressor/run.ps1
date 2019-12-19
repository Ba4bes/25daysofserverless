using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

$header = @{
    Authorization = $ENV:SASKey
}
$datetime = Get-Date
$Body = @{
    datetime     = $datetime
    deviceClient = "Compressor"
    Message      = "Start"
}

$URL = $ENV:HubUrl
$Tanklevel = 0
Write-output " Start-Compressor"
do {
    $datetime = Get-Date
    $Body = @{
        datetime     = $datetime
        deviceClient = "Compressor"
        Message      = "Start"
    }
    Invoke-RestMethod -Method POST -Uri $URL -Body ($Body | ConvertTo-Json) -Headers $header -ContentType "application/json"
    $Tanklevel
    Start-Sleep  60
    $Tanklevel = [math]::Round(($Tanklevel + 25), 1)

} while ($tanklevel -lt 200)

$datetime = Get-Date
$Body = @{
    datetime     = $datetime
    deviceClient = "Compressor"
    Message      = "Stop"
}
Invoke-RestMethod -Method POST -Uri $URL -Body ($Body | ConvertTo-Json) -Headers $header -ContentType "application/json"
