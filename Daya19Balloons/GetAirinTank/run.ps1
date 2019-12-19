using namespace System.Net
# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, [object]$InputBlob)
Write-Host $InputBlob
$Message = $inputBlob.Message
$DateTime = $inputBlob.datetime

If ($Message -eq "Stop") {
    $AirAmount = 200
    $Action = "Stopped"
}
elseif ($Message -eq "Start") {
    $TimeDif = ((Get-Date) - $DateTime)
    $AirAmount = $TimeDif.Minutes * 25
    if ($AirAmount -gt 200) { $AirAmount = 200 }
    $Action = "Started"
}
else {
    $Status = [HttpStatusCode]::BadRequest
    $HTML = "No Message received"
}
if (-not $Status) {
    [decimal]$Balloons = $AirAmount/0.6
    $Balloons = [math]::Floor($Balloons)
    $Status = [HttpStatusCode]::OK
    $HTML = "The Tank $Action filling at $Datetime. <br> At this point you have $AirAmount, which will fill $Balloons Balloons "
}
Write-Host $AirAmount
Write-Host $Action

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = $Status
        ContentType = "text/html"
        Body        = $HTML
    })
