param($eventHubMessages, $TriggerMetadata)

Write-Host "PowerShell eventhub trigger function called for message array: $eventHubMessages"

$eventHubMessages | ForEach-Object { Write-Host "Processed message: $_" }
$eventHubMessages

Push-OutputBinding -Name OutputBlob -Value $eventHubMessages
