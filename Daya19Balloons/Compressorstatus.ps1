
$header = @{
    Authorization = "SharedAccessSignature sr=4besday17HUB.azure-devices.net%2Fdevices%2FCompressor&sig=qWahXinfvZrUngX37C%2Fs%2FWo7nrM9NIzuj0v1AWJpeyE%3D&se=1576789931"
}
$datetime = Get-Date
$Body = @{
    datetime     = $datetime
    deviceClient = "Compressor"
    Message      = "Start"
}

$URL = "https://4besday17HUB.azure-devices.net/devices/Compressor/messages/events?api-version=2018-04-01"
do {
    $Tanklevel = 200

    do {
        $BalloonWaitTime = 1..5 | Get-Random
        Write-Output "start sleep for $balloonwaittime"
        Start-Sleep -Milliseconds $BalloonWaitTime
        #Fill the balloon
        $Tanklevel = [math]::Round(($Tanklevel - 0.6), 1)
        $Tanklevel
    } while ($Tanklevel -gt 0.6)

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
        Start-Sleep 1
        $Tanklevel = [math]::Round(($Tanklevel + 25), 1)

    } while ($tanklevel -lt 200)
    $datetime = Get-Date
    $Body = @{
        datetime     = $datetime
        deviceClient = "Compressor"
        Message      = "Stop"
    }
    Invoke-RestMethod -Method POST -Uri $URL -Body ($Body | ConvertTo-Json) -Headers $header -ContentType "application/json"
} while ($true)