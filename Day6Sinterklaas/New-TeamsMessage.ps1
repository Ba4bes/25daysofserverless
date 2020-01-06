<#
.SYNOPSIS
    This simple function sends a message to teams
.DESCRIPTION
    The function takes input and sends it to teams through a webhook
.PARAMETER Message
    String, the message that needs to be send.
.EXAMPLE
    New-TeamsMessage -Message "this is a message"
.NOTES
    This is an Automation account runbook, originally made for 25DaysofServerless.com
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>
Param(
    [Parameter(Mandatory = $true)]
    [String]$Message
)

$jsonobject = @{
    text = "ALERT! $Message"
}
Invoke-RestMethod -Method POST -Uri "https://outlook.office.com/webhook/123456-123-123-123-12345678@123456-123-123-123-12345678/IncomingWebhook/123456-123-123-123-12345678/123456-123-123-123-12345678" -ContentType "Application/JSON" -Body ($JSONobject | ConvertTo-Json)

