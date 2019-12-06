[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [String]$Message
)

$jsonobject = @{
    text = "ALERT! $Message"
}
Invoke-RestMethod -Method POST -Uri "https://outlook.office.com/webhook/123456-123-123-123-12345678@123456-123-123-123-12345678/IncomingWebhook/123456-123-123-123-12345678/123456-123-123-123-12345678" -ContentType "Application/JSON" -Body ($JSONobject | ConvertTo-Json)

