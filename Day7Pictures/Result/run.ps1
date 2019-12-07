using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

$SearchItem = $TriggerMetadata.SearchItem
Write-Output "you said $SearchItem"


$CLientID = $ENV:UnsplashApiKey
Write-Output "key: $ClientID"
$Header = @{
    Authorization = "Client-ID $ClientID"
}

    $URL = "https://api.unsplash.com/photos/random?query=$SearchItem"
    $Image = Invoke-RestMethod -Method GET -Headers $Header -Uri $URL
    $HTML = @"
<h1>$SearchItem</h1>
<img src = $($image.urls.regular)>
"@
    $Status = [HttpStatusCode]::OK
# }
# Catch {
#     $status = [HttpStatusCode]::BadRequest
#     $HTML = "Something went wrong, please try again"
# }

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = $Status
        ContentType = "text/html"
        Body        = $HTML
    })
