using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

Switch ($Request.Query.Result) {
    "Yes" { $Score = ([int]$Request.Query.Score + 0.1) }
    "No" { $Score = ([int]$Request.Query.Score - 0.1) }
    Default { Continue }
}
$Object = [PSCustomObject]@{
    ID    = $Request.Query.ID
    Line  = $Request.Query.ID
    Score = $Score
}
Write-host "Changed line:" $Object.ID
Write-Host "New Score:" $Object.Score
$status = [HttpStatusCode]::OK
$body = "Thank you! Your message has been received"

Push-OutputBinding -Name Documents -Value $Object

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $status
        Body       = $body
    })
