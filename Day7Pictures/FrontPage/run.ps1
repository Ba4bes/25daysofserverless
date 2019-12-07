using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)
Write-Host "PowerShell HTTP trigger function processed a request."
$form = @"
<html>
<body>
<h1>la quema del diablo</h1>
<form action='http://4besday7.azurewebsites.net/Result'>
What do you want to throw away? <input type='text' name='SearchItem'><br>
<input type='submit' value='Submit'>
</form>

<p>

</body>
"@


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = "ok"
    ContentType = "text/html"
    Body = $form
})
