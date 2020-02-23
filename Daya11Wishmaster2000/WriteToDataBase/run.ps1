using namespace System.Net
<#
.SYNOPSIS
    This Azure Function App takes input from an HTML form (Function FrontPage)and puts it as an object in a cosmosDB
.DESCRIPTION
    This Azure Function App takes input through a HTML form that asks for the needed information.
    It returns a http-response to the requester to confirm the input.
    The forminformation is added to a Database.
    If an entry with that name already exists, it is changed
.INPUTS
    Object with:
    ChildsName
    Address
    Wish
    Present
.OUTPUTS
    The information is send to a CosmosDB
    A http response is send.
.NOTES
    This is an Azure Function App, originally made for 25DaysofServerless.com
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
Write-Output "Request:"
$Request

Write-Output "Metadata"
$TriggerMetadata

# Create an object to give to the database
$ChildObject = [PSCustomObject]@{
    id         = $Request.Query.ChildsName
    ChildsName = $Request.Query.ChildsName
    Address    = $Request.Query.Address
    Wish       = $Request.Query.Wish
    Present    = $Request.Query.Present
}

Write-Output 'ChildObject'
$ChildObject

# Check if a Childname has been given, otherwise there is no ID available
if ($ChildObject.ChildsName) {
    # Create a HTTP output to return
    $status = [HttpStatusCode]::OK
    $body = "Thank you $($ChildObject.ChildsName)!, your message has been received"

    # Push the object to the database
    Push-OutputBinding -Name Documents -Value $ChildObject
}
else {
    $status = [HttpStatusCode]::BadRequest
    $body = "I'm sorry, I did not get that"
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $status
        Body       = $body
    })
