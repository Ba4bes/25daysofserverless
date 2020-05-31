using namespace System.Net
<#
.SYNOPSIS
    This Function calls a html-form where the user can give an input
.DESCRIPTION
    TAn HTMLform is returned to the user.
    The input is then given to the second function called "Result"
.INPUTS
    a webrequest through a browser
.OUTPUTS
    an HTML page with a form
.NOTES
    This is an Azure Function App, originally made for 25DaysofServerless.com
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>
# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)
Write-Host "PowerShell HTTP trigger function processed a request."

# Get the FunctionAppURL for the resultFunction
Write-Host $TriggerMetadata.request.url
$URL = $TriggerMetadata.Request.Url
$FunctionAppUrl = $URL -replace "FrontPage", "Result"

$form = @"
<html>
<body>
<h1>Weihnachtsmarkt</h1>
<form action='$FunctionAppUrl'>
Search for the image to send <input type='text' name='SearchItem'><br><br>
<input type='submit' value='Submit'>
</form>

<p>

</body>
"@

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode  = [HttpStatusCode]::OK
    ContentType = "text/html"
    Body        = $Form
})
