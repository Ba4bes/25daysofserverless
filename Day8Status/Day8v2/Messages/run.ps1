using namespace System.Net
<#
.SYNOPSIS
    This function takes input from an HTML form and sends it to a statuspage
.DESCRIPTION
    The input that is created in a HTML form gets the date added.
    This information is send to a status page through SignalR
.INPUTS
    HTTPtrigger through a webform
.OUTPUTS
    - SignalR service message to a status page
    - a HTML output to tell the user if the function worked
.NOTES
    This is an Azure Function App, originally made for 25DaysofServerless.com
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>
param($Request, $TriggerMetadata)
try {
    $Date = Get-Date ([datetime]::UtcNow) -Format "dd-MMM-yyyy HH:mm:ss"
    $Input = @{
        status  = $TriggerMetadata.status
        date    = $Date
        sender  = $TriggerMetadata.sender
        message = $TriggerMetadata.message
    }

    write-Host "Input"
    $Input
    $message = [PSCustomObject]@{
        Target    = "newMessage"
        Arguments = @($Input)
    }
    Push-OutputBinding -Name SignalRMessages -Value $message

    $Status = [HttpStatusCode]::OK
    $HTML = "The status has been updated"
}
Catch {
    $Status = [HttpStatusCode]::BadRequest
    $HTML = "Something went wrong, please try again"
}
# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = $Status
        ContentType = "text/html"
        Body        = $HTML
    })
