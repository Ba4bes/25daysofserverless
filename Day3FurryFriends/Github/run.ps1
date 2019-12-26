using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Collect the files that were commited and select the PNGs only
$AddedPNGs = $Request.Body.commits.added | Where-Object { $_ -like "*.png" }

Write-Output "Added PNGs: $AddedPNGs"

# Perform an action when PNGs are added
if ($AddedPNGs.Count -ne 0) {
    foreach ($AddedPNG in $AddedPNGs) {
        # Create the URL where the image is found
        $URL = "https://github.com/Ba4bes/25daysofserverless/blob/master/" + ( $AddedPNG -replace " ", "%20")

        # This outputbinding is to create a message in the storage queue for each PNG
        Push-OutputBinding -Name ImageQueue -Value $URL
    }
}

# Create a body and OutputBinding so the webhook has a response and knows the request was successful.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = "Thank You"
    })
