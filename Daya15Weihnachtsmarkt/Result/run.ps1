using namespace System.Net
<#
.SYNOPSIS
    Searches an image in Unsplash and gives it back in the output
.DESCRIPTION
    A searchitem is found in the metadata. 
    This term is used to search an image in Unsplash.
    The image is returned in an HTML page
.INPUTS
    the output of the FrontPageFunction
.OUTPUTS
    an HTML page
.NOTES
    This is an Azure Function App, originally made for 25DaysofServerless.com
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>
# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# The input from the form is stored in the Triggermetadata
$SearchItem = $TriggerMetadata.SearchItem
Write-Output "you said $SearchItem"

# The key for the UnsplashAPI is stored in the environmentVariabled
$USKey = $ENV:UnSplashKey

# Create a header to call the API
$Header = @{
    Authorization = "Client-ID $USKey"
}

    # Find an image through the Unsplash API
    $URL = "https://api.unsplash.com/photos/random?query=$SearchItem"
    $Image = Invoke-RestMethod -Method GET -Headers $Header -Uri $URL

    # Check if an image has been found.
if ($null -eq $Image) {
    $Status = [HttpStatusCode]::BadRequest
    $HTML = "Image not found"
}
else {
    # Get the tags from the cognitive services API
    $DescribeHeader = @{
        "ocp-apim-subscription-key" = $ENV:ComputerVisionKey
    }
    $Body = @{
        "url" = $($image.urls.small)
    }
    $ImageURL = "http://westeurope.api.cognitive.microsoft.com/vision/v2.0/describe"
    $Parameters = @{
        Method      = "POST"
        Uri         = $ImageURL
        Headers     = $DescribeHeader
        Body        = ($Body | ConvertTo-Json) 
        ContentType = "application/json"
    }
    $ImageResults = Invoke-RestMethod @Parameters

    if ($null -eq $ImageResults) {
        $Status = [HttpStatusCode]::BadRequest
        $HTML = "Image found, but could not be analyzed"
    }
    else {
        # Create an HTML table for the description
        $Description = ($ImageResults.description.captions) | ConvertTo-Html
        $Tags = @()
        $i = 0
        # Create an HTML output with the tags
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
