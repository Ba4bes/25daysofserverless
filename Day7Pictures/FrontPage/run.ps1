using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)
Write-Host "PowerShell HTTP trigger function processed a request."

$FunctionName = $($TriggerMetadata.FunctionName)

# This is a lazy string to get some input
$Form = @"
<html>
<body>
<h1>la quema del diablo</h1>
<form action='http://4besday7.azurewebsites.net/Result'>
What are you looking for? <input type='text' name='SearchItem'><br>
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
