using namespace System.Net
<#
.SYNOPSIS
    This function takes a user input from a form
    The result is pushed to a CosmosDB
.DESCRIPTION
    When the function is called, it checks the result for the joke.
    It changes the score for the joke depending on results.
    The result is written back to the Cosmos DB.
.INPUTS
    An HTTP request through a form
.OUTPUTS
    HTML output that shows a form
    An update to Cosmos
.NOTES
    This is an Azure Function App, originally made for 25DaysofServerless.com
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>
# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

Write-Output "REQUEST Query"
$Request.Query
# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Use a switch to see if the result was positive or not
# Change the score accordingly
Write-Output "Checking Result"
Write-Output $Request.Query.Result
Switch ($Request.Query.Result) {
    "Yes" { $Score = ([decimal]$Request.Query.Score + 0.1) }
    "No" { $Score = ([decimal]$Request.Query.Score - 0.1) }
    Default { Continue }
}
Write-Output "The joke"
Write-Output $Request.Query.Line
# Create a new object to write to the Cosmos DB
$Object = [PSCustomObject]@{
    id    = $Request.Query.id
    Line  = $Request.Query.Line
    Score = $Score
}
Write-Host "Changed line:" 
$Object.Line
Write-Host "New Score:" 
$Object.Score
Write-Host 'id =' 
$Object.id
# Push the new object to the Cosmos DB
Push-OutputBinding -Name Documents -Value $Object

# Create a body to give back to the caller
$URL = $TriggerMetadata.Request.Url
$FunctionAppUrl = $URL -replace "ChangeScore", "GetJoke"
$Body = @"
Thank you! The joke has been updated. 

<a href = $FunctionAppUrl>Rate another</a>
"@

# Create an output for the caller
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        ContentType = "text/html"
        Body       = $Body
    })
