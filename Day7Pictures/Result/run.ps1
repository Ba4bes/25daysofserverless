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
$USKey = $ENV:UnsplashApiKey

# Create a header to call the API
$Header = @{
    Authorization = "Client-ID $USKey"
}
Try {
    # Find an image through the Unsplash API
    $URL = "https://api.unsplash.com/photos/random?query=$SearchItem"
    $Image = Invoke-RestMethod -Method GET -Headers $Header -Uri $URL

    # Create a HTML-string to show the image
    $HTML = @"
<h1>$SearchItem</h1>
<img src = $($image.urls.regular)>
"@
    $Status = [HttpStatusCode]::OK
}
Catch {
    Write-Host "Error"
    Write-Host $_
    $status = [HttpStatusCode]::BadRequest
    $HTML = "Something went wrong, please try again"
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = $Status
        ContentType = "text/html"
        Body        = $HTML
    })
