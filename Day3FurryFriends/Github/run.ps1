using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
$addedpngs = $Request.Body.commits.added | Where-Object { $_ -like "*.png" }
Write-Output "request;" $Request.Body.Commits.Added
Write-output "pngs; $addedpngs"
if ($addedpngs.Count -ne 0) {
    foreach ($addedpng in $addedpngs) {
        $URL = "https://github.com/Ba4bes/25daysofserverless/blob/master/" + ( $addedpng -replace " ", "%20")
        Push-OutputBinding -Name ImageQueue -Value $URL
    }
}
$body = "thankyou"

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = "OK"
        Body       = $body
    })
