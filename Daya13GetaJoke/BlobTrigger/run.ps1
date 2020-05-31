<#
.SYNOPSIS
    This Azure Function App takes input from a storage account
    checks it in cognitive services and outputs it to CosmosDB
.DESCRIPTION
    A text file is stored in a storage blob.
    The lines are collected and checked for a score against cognitive services
    The lines and scores are uploaded to a Cosmos DB.
.INPUTS
    A txt file in a storage blob
    The secret is collected from Azure Keyvault
.OUTPUTS
    Entries in a CosmosDB
.NOTES
    This is an Azure Function App, originally made for 25DaysofServerless.com
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>

# Input bindings are passed in via param block.
param([string]$InputBlob, $TriggerMetadata)

# Write out the blob name and size to the information log.
Write-Host "PowerShell Blob trigger function Processed blob! Name: $($TriggerMetadata.Name) Size: $($InputBlob.Length) bytes"

# Create a header for the analytics API
# The key is pulled from Keyvault
$analyticsheader = @{
    "Ocp-Apim-Subscription-Key" = (Get-AzKeyVaultSecret -VaultName forbesDay5 -Name AnalyticsKey).SecretValueText
    "Content-Type"              = "application/json"
}

# Create an arraylist to store the jokes
[System.Collections.ArrayList]$JokeArray = @()

# An array is created by splitting the textfile that contains the input data
$InputArray = $inputBlob.Split([Environment]::NewLine, [StringSplitOptions]::RemoveEmptyEntries)

Write-Output "starting foreachloop"
# Moving through every joke in the Array
foreach ($Line in $InputArray) {
    # Create a body for the Analytics Service
    $abody = @{
        "language" = "en"
        "id"       = "1"
        "text"     = $Line
    }
    $Body = @{"Documents" = @($abody) } | ConvertTo-Json

    # Call the API to collect a score
    $Splat = @{
        Method  = "POST"
        Body    = $Body
        Headers = $analyticsheader
        uri     = "https://westeurope.api.cognitive.microsoft.com/text/analytics/v2.1/sentiment"
    }
    $Score = Invoke-RestMethod @Splat

    # Create an object to store in the CosmosDB
    $Object = [PSCustomObject]@{
        id    = (New-Guid).Guid
        Line  = $Line
        Score = $score.documents.Score
    }
    Write-Output  $score.documents.Score
    # Put the joke in the Array so it can be pushed to CosmosDB
    $JokeArray.add($Object)
}

# Push the array to CosmosDB
Push-OutputBinding -Name Documents -Value $JokeArray
