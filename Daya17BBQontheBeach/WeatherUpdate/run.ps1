param($eventHubMessages, $TriggerMetadata)

$Message = @{
    "@type"      = "MessageCard"
    "@context"   = "https://schema.org/extensions"
    "summary"    = "A new message has arived!"
    "themeColor" = "0078D7"
    "title"      = "IT'S BBQ TIME!!!"
    "sections"   = @(
        @{
            "facts"    = @(
                [PSCustomObject]@{
                    "name"  = "Time"
                    "value" = (get-date).DateTime
                }
                [PSCustomObject]@{
                    "name"  = "Temp"
                    "value" = $EventhubMessages.temperature
                }
            )
            "text"     = "Lets Go!!!!"
            "markdown" = "true"
        }
    )
}

if ($eventHubMessages.temperature -gt 31) {
    $URl = "https://outlook.office.com/webhook/c22dca3d-9e1f-4aac-9db0-0ace22705b8f@1b1d5937-2928-433a-873e-8acc5fd8145a/IncomingWebhook/37394fd4274149ecaf03ea51ee7c52ad/cac3e837-4691-4e23-a9d8-858ac6afec4e"
    Invoke-RestMethod -Method POST -Uri $url -ContentType "Application/JSON" -Body  ($message | ConvertTo-Json -Depth 5)
    Write-host "warm!"
    $eventHubMessages.temperature
}
else {
    Write-host "cold!"
    $eventHubMessages.temperature
}


