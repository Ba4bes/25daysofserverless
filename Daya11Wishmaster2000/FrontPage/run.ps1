using namespace System.Net
<#
.SYNOPSIS
    This Function calls a html-form where the user can give an input
.DESCRIPTION
    An HTMLform is returned to the user.
    The input is then given to the second function called "WriteToDatabase"
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

$URL = $TriggerMetadata.Request.Url
$FunctionAppUrl = $URL -replace "FrontPage", "WriteToDatabase"


$form = @"
<html>
<body>
<h1>Santa's contact form</h1>
<form action='$FunctionAppUrl'>
What is you Name? <input type='text' name='ChildsName'><br>
What is your address? <input type='text' name='Address'><br>
What is your wish? <input type='text' name='Wish'><br>
What present do you want? <input type='text' name='Present'><br>
<input type='submit' value='Submit'>
</form>

<p>

</body>
"@


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = [HttpStatusCode]::OK
        ContentType = "text/html"
        Body        = $form
    })