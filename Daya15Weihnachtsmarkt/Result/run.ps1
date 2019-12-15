using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

$SearchItem = $TriggerMetadata.SearchItem
Write-Output "you said $SearchItem"

$CLientID = $ENV:UnSplashKey

$Header = @{
    Authorization = "Client-ID $ClientID"
}

$URL = "https://api.unsplash.com/photos/random?query=$SearchItem"
$Image = Invoke-RestMethod -Method GET -Headers $Header -Uri $URL
if ($null -eq $Image) {
    $Status = [HttpStatusCode]::BadRequest
    $HTML = "Image not found"
}
else {
    $ComputeKey = $ENV:ComputerVisionKey
    $DescribeHeader = @{
        "ocp-apim-subscription-key" = $ComputeKey
    }
    $Body = @{
        "url" = $($image.urls.small)
    }
    $ImageURL = "http://westeurope.api.cognitive.microsoft.com/vision/v2.0/describe"

    $ImageResults = Invoke-RestMethod -Method POST -Uri $ImageURL -Headers $DescribeHeader -Body ($Body | ConvertTo-Json) -ContentType application/json
    if ($null -eq $ImageResults) {
        $Status = [HttpStatusCode]::BadRequest
        $HTML = "Image found, but could not be analyzed"
    }
    else {
        $Description = ($ImageResults.description.captions) | ConvertTo-Html

        $Tags = @()
        $i = 0
        foreach ($Tag in $ImageResults.description.tags ) {
            $Tags += " <span class='boxed'>  $Tag  </span> "
            if ($i % 5 -eq 0) {
                $Tags += "<br>"
            }
            $i ++
        }

        $HTML = @"
<style>
BODY {font-family:verdana;}
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; padding: 5px; background-color: #d1c3cd;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black; padding: 5px}
.boxed {border: 1px solid #000; border-radius: 2px; display: inline-block; margin-bottom: 5px; padding: 1px 10px 1px;
}
</style><center>
<h1>$SearchItem</h1>
<img src = $($image.urls.small)>
<h2>Description</h2>
$Description
<h2>Tags</h2>
$Tags
</center>
"@

        $Status = [HttpStatusCode]::OK
    }
}
# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = $Status
        ContentType = "text/html"
        Body        = $HTML
    })
