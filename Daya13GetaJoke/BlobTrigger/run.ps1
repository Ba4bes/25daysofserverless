# Input bindings are passed in via param block.
param([string] $InputBlob, $TriggerMetadata)

# Write out the blob name and size to the information log.
Write-Host "PowerShell Blob trigger function Processed blob! Name: $($TriggerMetadata.Name) Size: $($InputBlob.Length) bytes"
Write-Host "blob"

$analyticsheader = @{
    "Ocp-Apim-Subscription-Key" = (Get-AzKeyVaultSecret -VaultName forbesDay5 -Name AnalyticsKey).SecretValueText
    "Content-Type"              = "application/json"
}


$score = 1
$Array = @()
$inputarray = $inputBlob.Split([Environment]::NewLine, [StringSplitOptions]::RemoveEmptyEntries)
#$Content = Get-Content ".\Jokes.txt"
foreach ($Line in $InputArray) {

    $abody = @{
        "language" = "en"
        "id"       = "1"
        "text"     = $Line
    }
    $Body = @{"Documents" = @($abody) } | ConvertTo-Json

    $Score = Invoke-RestMethod -Method POST -Body $Body -Headers $analyticsheader -uri "https://westeurope.api.cognitive.microsoft.com/text/analytics/v2.1/sentiment"

    $Object = [PSCustomObject]@{
        ID    = $Line
        Line  = $Line
        Score = $score.documents.Score
    }
    Write-Output  $score.documents.Score

    $Array += $Object

}

Push-OutputBinding -Name Documents -Value $Array
