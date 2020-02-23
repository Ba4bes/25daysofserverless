<#
.SYNOPSIS
    This function takes database input and sends a message to teams
.DESCRIPTION
    This function is triggered by a new DatabaseEntry.
    When it arrives, it's data is formatted for teams.
    It is then send throug a webhook
.INPUTS
    A new database entry for a cosmosDB
.OUTPUTS
    A message to a teamschannel through a webhook.
.NOTES
    This is an Azure Function App, originally made for 25DaysofServerless.com
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>

# Input bindings are passed in via param block.
param($Documents, $TriggerMetadata)

if ($Documents.Count -gt 0) {
    Write-Host "Document Id: $($Documents[0].id)"
}

write-host $Documents
# Collect the first entry
$newMessage = $Documents[0]

# Create an object to send to Teams
$TeamsBody = @{
    "@type"      = "MessageCard"
    "@context"   = "https://schema.org/extensions"
    "summary"    = "A new message has arived!"
    "themeColor" = "0078D7"
    "title"      = "A new message has arived!"
    "sections"   = @(
        @{
            "facts"    = @(
                @{
                    "name"  = "childName:"
                    "value" = "$($NewMessage.ChildsName)"
                },
                @{
                    "name"  = "Address:"
                    "value" = "$($NewMessage.Address)"
                },
                @{
                    "name"  = "Wish:"
                    "value" = "$($NewMessage.Wish)"
                },
                @{
                    "name"  = "Present:"
                    "value" = "$($NewMessage.Present)"
                }
            )
            "text"     = "A new message has arived!"
            "markdown" = "true"
        }
    )
}

# The URL is stored in the variables. The webhook is called to send a message to Teams.
Invoke-RestMethod -Method POST -Uri "$ENV:teamsWebHook" -ContentType "Application/JSON" -Body ($TeamsBody | ConvertTo-Json -Depth 10)