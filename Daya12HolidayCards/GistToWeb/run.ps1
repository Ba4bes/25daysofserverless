using namespace System.Net
<#
.SYNOPSIS
    This Azure Function App takes a GitHub Gist in markdown and translates it to HTML
.DESCRIPTION
    A ID is provided. From that ID, the content of the Gist is collected.
    If the gist contains markdown, it is translated to HTML.
    To do this it uses the GitHub API.
    The HTML is returned raw or formatted, based on the RAW-parameter
.INPUTS
    An HTML Request
    GistID for the GithubID
    Raw=True for giving a raw output, otherwise the output is formatted
.OUTPUTS
    HTML file, formatted or raw based on the Raw-parameter
.NOTES
    This is an Azure Function App, originally made for 25DaysofServerless.com
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# The ID is passed in the request
$GistID = $Request.Query.GistID

# Give an Error and stop the script if the GistID is empty
if ([string]::IsNullOrEmpty($GistID)) {
    $status = [HttpStatusCode]::BadRequest
    $body = "Please provide a GistID"
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode = $status
            Body       = $body
        })
    Exit
}

# Get the gistfile through the GITAPI
$Result = Invoke-Restmethod -Method GET -Uri "https://api.Github.com/gists/$GistID"

# There can be more than one file in a gist. if there are, an arraylist is created
$FileNames = $result.files | Get-Member -MemberType NoteProperty
if ($FileNames.Count -gt 1) {
    Write-Output "More than one file in Gist, creating ArrayList"
    [System.Collections.ArrayList]$AllFiles = @()
}
foreach ($File in $FileNames) {
    # Check if the file is a markdownfile
    if ($Result.files.($File.Name).Language -eq "MarkDown") {

        $RawURL = $Result.files.($File.Name).raw_url
        # Get the raw file to work with
        $MDGist = Invoke-RestMethod -Method GET -Uri $RawURL

        $Body = @{
            "text" = $MDGist
            "mode" = "markdown"

        }
        # Use the GitHub API to translate the markdown to HTML
        $response = Invoke-WebRequest -Method Post -Uri "https://api.github.com/markdown" -Body ($body | ConvertTo-Json)

        $HTMLFile = $response.Content
        # Add results to arraylist if more than one file was called
        if ($FileNames.Count -gt 1) {
            $AllFiles.Add($HTMLFile)
        }
    }
    else {
        Write-Output "$($File.Name) is not a MarkdownFile."
    }
}
# If more than one file was called, collect them in one body
if ($AllFiles.Count -gt 0) {
    $Status = [HttpStatusCode]::OK
    $Body = $AllFiles -join ""
}
# Otherwise, just put the HTML output in the body
Elseif ($HTMLFile) {
    $Status = [HttpStatusCode]::OK
    $Body = $HTMLFile
}
Else {
    # If no results are found, create an error
    $status = [HttpStatusCode]::BadRequest
    $body = "File $($File.Name) is not a MarkDownFile."
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode = $status
            Body       = $body
        })
    Exit
}

# If the Raw-parameter is passed, the text is given raw
If ($Request.Query.Raw) {
    $ContentType = "text/plain"
}
# If not, it is set up to be formatted
else {
    $ContentType = "text/html"
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = $status
        ContentType = $ContentType
        Body        = $body
    })
