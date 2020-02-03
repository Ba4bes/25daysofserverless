using namespace System.Net
<#
.SYNOPSIS
    This function is a default function to negotiate the connection with SignalR
.DESCRIPTION
    This function is a default function to negotiate the connection with SignalR
.NOTES
    This is an Azure Function App, originally made for 25DaysofServerless.com
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>
param($Request, $TriggerMetadata, $ConnectionInfo)

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = [HttpStatusCode]::OK
        ContentType = "application/json"
        Body        = $ConnectionInfo
    })