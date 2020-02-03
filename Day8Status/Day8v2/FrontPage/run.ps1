using namespace System.Net
<#
.SYNOPSIS
    This Function calls a html-form where the user can give an input
.DESCRIPTION
    An HTMLform is returned to the user.
    The input is then given to the second function called "Messages"
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
$FunctionAppUrl = $URL -replace "FrontPage", "Messages"

# To get the input from the user, a simple HTMLform is used.
$Form = @"
<html>

<body>
    <h1>StatusUpdate</h1>
    <form action='$FunctionAppUrl'>
        <strong> What is the current status?<br>
            <input type="radio" name="status" id="open" value="open"> Open<br>
            <input type="radio" name="status" id="closed" value="closed"> Closed<br>
            <input type="radio" name="status" id="ongoing" value="ongoing"> Ongoing<br><br>
            Your name<br>
            <input type='text' name='sender'><br><br>
            Enter the update message here<br>
            <textarea name="message" rows="10" cols="30"></textarea>
            <br><br>
            <input type="submit" value="Submit">
    </form>
    <p>
</body>

</html>
"@

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = [HttpStatusCode]::OK
        ContentType = "text/html"
        Body        = $Form
    })
