using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $Documents)


$Best10 = $Documents | Sort-Object -Property Score -Descending | Select-Object -First 25

$randomResult = $Best10 | Get-Random -Count 1
Write-Output $randomResult

$HTML = @"
<h1>This is a joke! :-D</h1>
<h2>$($RandomResult.Line)</h2>
<p><p>
This joke has a score of $($RandomResult.Score)<br>
Tell us if this is a good joke<p>
<form action='https://4besday13.azurewebsites.net/api/ChangeScore'>
<br>
<input type='hidden' name='ID' value='$($RandomResult.ID)'><p>
<input type='hidden' name='Score' value='$($RandomResult.Score)'><p>

  <input type='radio' name='Result' value='Yes' checked> Yes<br>
  <input type='radio' name='Result' value='No'> No<br>

  <input type='submit' value='Submit'>
</form>
"@

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = [HttpStatusCode]::OK
        ContentType = "text/html"
        Body        = $HTML
    })