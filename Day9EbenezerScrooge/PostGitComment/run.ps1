using namespace System.Net
<#
.SYNOPSIS
    This script will create a github comment when a new issue is created
.DESCRIPTION
    This script will be called by a webhook at the Github repository.
    If a new issue was placed, it will create a comment for the issue
.INPUTS
    Schould be called by the Github API with a webhook.
    The request should contain information from the repository
.OUTPUTS
    The call is answered with a status code.
    An API call is made to Github to create a new comment
.NOTES
    This is an Azure Function App, originally made for 25DaysofServerless.com
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>
# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Output $Request.Body

# Collect information from the input from GitHub
$Body = $request.Body
$username = $Body.issue.user.login

# Results are only needed if a new issue is opened.
if ($Body.action -eq "Opened") {
    $OutputBody = " :christmas_tree: Hello $username, Thank you for your message :sparkles: :smiley:. "

    # The credentials are saved in the Environment credentials
    [string]$token = $ENV:GHtoken
    [string]$user = $ENV:GHUser
    # Create a header to give back to the Github API
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $User, $Token)))
    $Header = @{
        Authorization = ("Basic {0}" -f $base64AuthInfo)
    }
    Write-Output "body" $OutputBody
    # Create the body for the Github API
    $BodyJSON = (@{body = $OutputBody } | ConvertTo-Json)
    Write-output "BodyJSON" $BodyJSON

    # Post to the Github API. The URL is created from the request
    $Splat = @{
        Headers     = $Header
        Method      = "POST"
        Uri         = "$($body.issue.url)/comments"
        body        = $BodyJSON
        ContentType = "application/JSON"
    }
    Invoke-RestMethod @Splat
}

# Create an outputBody as a respons to the web hook call.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = $Body
    })
