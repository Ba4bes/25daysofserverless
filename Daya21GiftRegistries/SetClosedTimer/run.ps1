# Input bindings are passed in via param block.
param($Documents, $TriggerMetadata)

if ($Documents.Count -gt 0) {
    Write-Host "Document Id: $($Documents[0].id)"
}

Write-output "starting sleep"
Start-sleep 360
Invoke-RestMethod -Method POST -Uri "$($ENV:FunctionAppURL)/api/FinishRegistry?id=$($Documents[0].id)"
