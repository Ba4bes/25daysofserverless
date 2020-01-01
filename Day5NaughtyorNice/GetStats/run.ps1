using namespace System.Net

<#
.SYNOPSIS
    This Azure Function App gets set messages, translates them and analyzes the possitivity
.DESCRIPTION
    The messages are collected from an API call. First the languages are detected.
    After that the message is translated and checked for positivity.
    The messages are collected for each child to find out if they were nice or naughty
.EXAMPLE
    visit "https://4besday5.azurewebsites.net/api/GetStats"
.INPUTS
    Needs to be called in a webbrowser
.OUTPUTS
    A HTML based website with a table with information on the children
.NOTES
    This is an Azure Function App, originally made for 25DaysofServerless.com
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# First create the headers for the API requests. The keys are collected from a KeyVault Account.
$TranslateHeader = @{
    "Ocp-Apim-Subscription-Key" = (Get-AzKeyVaultSecret -VaultName forbesDay5 -Name translateKey).SecretValueText
    "Content-Type"              = "application/json"
}
$analyticsheader = @{
    "Ocp-Apim-Subscription-Key" = (Get-AzKeyVaultSecret -VaultName forbesDay5 -Name AnalyticsKey).SecretValueText
    "Content-Type"              = "application/json"
}

# The output will be a HTTP page with a table. Here we create a header for that page
$HTMLHeader = @"
<style>
BODY {font-family:verdana;}
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; padding: 5px; background-color: #d1c3cd;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black; padding: 5px}
</style>
"@

# Create an empty array for the results
$Results = @()

# The example messages are collected from an API.
# As there is more than one message for each kid, the childrens names are collected to collect all messages from each kid.
$Letters = Invoke-RestMethod -Method GET -URI https://christmaswishes.azurewebsites.net/api/Wishes
$Children = $Letters | Select-Object -Unique -Property Who

foreach ($Child in $Children) {
    # Create an array to collect the different scored for this child
    $AllScores = @()
    Write-Output $Child
    # Collected every letter written by this child and go throught them
    $Messages = $Letters | Where-Object { $_.Who -eq $Child.Who }
    foreach ($Message in $Messages) {
        if ([string]::IsNullOrEmpty($Message.message)) {
            Write-output "no message"
        }
        else {
            # Create a body and change it tot the correct format for translation to English
            $body = @{
                Text = $Message.message
            }
            $bodyjson = "[$($body | ConvertTo-Json)]"
            # Changes encoding to handle non-standard characters
            $jsondata = ([System.Text.Encoding]::UTF8.GetBytes($bodyjson))
            # Detect the language of the message
            $URI = "https://api.cognitive.microsofttranslator.com/detect?api-version=3.0"
            $Language = Invoke-RestMethod -Method POST -uri $URI -Headers $TranslateHeader -Body $jsondata

            # Translate the message to English.
            $URI = "https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&from=$($Language.Language)&to=en"
            $Result = Invoke-RestMethod -Method POST -uri $URI -headers $TranslateHeader -body $jsondata
            Write-Output $Result.translations.text

            # Create the body for the Analytics API call
            $AnyalyticsBody = @{
                "language" = "en"
                "id"       = "1"
                "text"     = "$($Result.translations.text)"
            }
            $AnalyticsJson = @{"Documents" = @($AnyalyticsBody) } | ConvertTo-Json

            # Get the score from the API
            $URI = "https://westeurope.api.cognitive.microsoft.com/text/analytics/v2.1/sentiment"
            $Score = Invoke-RestMethod -Method POST -uri $URI -Headers $AnalyticsHeader -Body $AnalyticsJson
            # Collect the API call and add it to the other scores this child has generated
            $AllScores += $Score.documents.score
        }
    }
    # Get the average score from all the different messages and give back a result based on that
    $AvScore = ($AllScores | Measure-Object -Average).Average
    if ([string]::IsNullOrEmpty($AllScores)) {
        Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
                StatusCode  = [HttpStatusCode]::BadRequest
                ContentType = "text/html"
                Body        = "Could not collect scores"
            })
        exit
    }
    elseif ($AvScore -gt 0.5) {
        $NaughtyorNice = "Nice"
    }
    elseif ($AvScore -lt 0.5) {
        $NaughtyorNice = "Naughty"
    }
    else {
        $NaughtyorNice = "Neutral"
    }
    # Create an object with all information
    $ChildObject = [pscustomobject]@{
        Name          = $Child.who
        Score         = $AvScore
        NaughtyorNice = $NaughtyorNice
    }


    # Add the created object tot the results
    $Results += $ChildObject
}

# Take the results and create an output with the Header
$HTML = $HTMLHeader + ($Results | ConvertTo-Html)

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = [HttpStatusCode]::OK
        ContentType = "text/html"
        Body        = $HTML
    })
