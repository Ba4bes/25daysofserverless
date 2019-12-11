# Input bindings are passed in via param block.
param($Documents, $TriggerMetadata)

if ($Documents.Count -gt 0) {
    Write-Host "Document Id: $($Documents[0].id)"
}
write-host $Documents
$newMessage = $Documents[0]
$JSON =@"
{
    "@type": "MessageCard",
    "@context": "https://schema.org/extensions",
    "summary": "A new message has arived!",
    "themeColor": "0078D7",
    "title": "A new message has arived!",
    "sections": [
        {
            "facts": [
                {
                    "name": "childName:",
                    "value": "$($NewMessage.ChildsName)"
                },
                {
                    "name": "Address",
                    "value": "$($NewMessage.Address)"
                },
                {
                    "name": "Wish:",
                    "value": "$($NewMessage.Wish)"
                },
                {
                    "name": "Present:",
                    "value": "$($NewMessage.Present)"
                }
            ],
            "text": "A new message has arived!",
            "markdown": true
        }
    ]
}
"@

$jsonobject = @{
    text = "ALERT! $($Documents[0].ChildName) has posted a message! $DOcuments"
}
Invoke-RestMethod -Method POST -Uri "$ENV:teamsWebHook" -ContentType "Application/JSON" -Body $JSON

