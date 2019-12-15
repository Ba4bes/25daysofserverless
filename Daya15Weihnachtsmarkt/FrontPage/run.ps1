using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)
Write-Host "PowerShell HTTP trigger function processed a request."
$form = @"
<html>
<body>
<h1>Weihnachtsmarkt</h1>
<form action='http://4besday15.azurewebsites.net//Result'>
Search for the image to send <input type='text' name='SearchItem'><br><br>
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
