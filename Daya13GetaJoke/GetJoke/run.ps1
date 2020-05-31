using namespace System.Net
<#
.SYNOPSIS
    This function displays a joke and asks to say if it is good or bad.
    The result is pushed to a different function
.DESCRIPTION
    A joke is collected from a Cosmos DB
    The joke is displayed in a HTML output and asks to rate the joke.
    The result is taken to a different function through a web form
.INPUTS
    An HTTP request
    Cosmos DB results
.OUTPUTS
    HTML output that shows a form
.NOTES
    This is an Azure Function App, originally made for 25DaysofServerless.com
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>
# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $Documents)

# Collect the 25 jokes that have the highest score
$Best25 = $Documents | Sort-Object -Property Score -Descending | Select-Object -First 25

# Collect a random joke from those 25 to set a score
$randomResult = $Best25 | Get-Random -Count 1
Write-Output $randomResult

$URL = $TriggerMetadata.Request.Url
$FunctionAppUrl = $URL -replace "GetJoke", "ChangeScore"

# Create a HTML form to give back as a response
# Information about the joke in the database is passed on through the hidden values.
$HTML = @"
<h1>This is a joke! :-D</h1><p>
<h2>$($RandomResult.Line)</h2>
<p><p>
This joke has a score of $($RandomResult.Score)<br>
Tell us if this is a good joke<p>
<form action='$FunctionAppUrl'>
<br>
<input type='hidden' name='id' value='$($RandomResult.id)'><p>
<input type='hidden' name='Score' value='$($RandomResult.Score)'><p>
<input type='hidden' name='Line' value='$($RandomResult.Line)'><p>
  <input type='radio' name='Result' value='Yes' checked> Yes<br>
  <input type='radio' name='Result' value='No'> No<br>

  <input type='submit' value='Submit'>
</form>
"@

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = [HttpStatusCode]::OK
        ContentType = "text/html"
        Body        = $HTML
    })