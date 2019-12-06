using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)


$Header = @{
    "Ocp-Apim-Subscription-Key" = (Get-AzKeyVaultSecret -VaultName forbesDay5 -Name translateKey).SecretValueText
    "Content-Type"              = "application/json"
}
$analyticsheader = @{
    "Ocp-Apim-Subscription-Key" = (Get-AzKeyVaultSecret -VaultName forbesDay5 -Name AnalyticsKey).SecretValueText
    "Content-Type"              = "application/json"
}
$HTMLHeader = @"
<style>
BODY {font-family:verdana;}
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; padding: 5px; background-color: #d1c3cd;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black; padding: 5px}
</style>
"@

# $token = Invoke-RestMethod -Method POST -header $header -uri 'https://api.cognitive.microsoft.com/sts/v1.0/issueToken'
$Results = @()

$letters = Invoke-RestMethod -Method GET https://christmaswishes.azurewebsites.net/api/Wishes
$Children = $letters | Select-Object -Unique -Property Who
foreach ($Child in $Children) {
    $AllScores = @()
    Write-Output $child
    $Messages = $Letters | Where-Object { $_.Who -eq $Child.Who }
    foreach ($Message in $Messages) {
        if ([string]::IsNullOrEmpty($Message.message)) { Write-output "no message" }
        else {
            $body = @{
                Text = $Message.message
            }
            $bodyjson = "[$($body | ConvertTo-Json)]"  #| foreach { [System.Text.RegularExpressions.Regex]::Unescape($_) } )]"
            $jsondata = ([System.Text.Encoding]::UTF8.GetBytes($bodyjson))
            $Language = Invoke-RestMethod -Method POST -uri "https://api.cognitive.microsofttranslator.com/detect?api-version=3.0" -Headers $header -Body $jsondata


            $Result = Invoke-RestMethod -Method POST "https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&from=$($Language.Language)&to=en" -header $header -body $jsondata
            $result.translations.text

            $abody = @{
                "language" = "en"
                "id"       = "1"
                "text"     = "$($result.translations.text)"
            }
            $documents = @{"Documents" = @($aBody) } | ConvertTo-Json
            $Score = Invoke-RestMethod -Method POST -Body $documents -Headers $analyticsheader -uri "https://westeurope.api.cognitive.microsoft.com/text/analytics/v2.1/sentiment"
            $AllScores += $score.documents.score
            $AvScore = ($AllScores | Measure-Object -Average).Average
            if ($AvScore -gt 0.5) {
                $NaughtyorNice = "Nice"
            }
            elseif ($AvScore -lt 0.5) {
                $NaughtyorNice = "Naughty"
            }
            else {
                $NaughtyorNice = "Neutral"
            }
            $ChildObject = [pscustomobject]@{
                Name          = $Child.who
                Score         = $AvScore
                NaughtyorNice = $NaughtyorNice
            }
        }
    }
    $Results += $ChildObject
}


$HTML = $HTMLHeader + ($Results | ConvertTo-Html)
# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = "ok"
        ContentType = "text/html"
        Body        = $HTML
    })
