using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)
Write-Host "PowerShell HTTP trigger function processed a request."
$form = @"
<html>
<body>
<h1>Santa's contact form</h1>
<form action='http://4besday11.azurewebsites.net/API/WriteToDatabase'>
What is you Name? <input type='text' name='ChildsName'><br>
What is your address? <input type='text' name='Address'><br>
What is your wish? <input type='text' name='Wish'><br>
What present do you want? <input type='text' name='Present'><br>
<input type='submit' value='Submit'>
</form>

<p>

</body>
"@

$Response = "<h1>Santa has received your message, thank you!</h1>"


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = "ok"
        ContentType = "text/html"
        Body        = $Form
    })