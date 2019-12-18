# Input bindings are passed in via param block.
param([byte[]] $InputBlob, $TriggerMetadata)

# Write out the blob name and size to the information log.
Write-Host "PowerShell Blob trigger function Processed blob! Name: $($TriggerMetadata.Name) Size: $($InputBlob.Length) bytes"


$ComputeKey = $ENV:ComputerVisionKey
$DescribeHeader = @{
    "ocp-apim-subscription-key" = $ComputeKey
}

#Get the tags for the image
$ImageURL = "https://westeurope.api.cognitive.microsoft.com/vision/v2.1/tag?en"
$ImageResults = Invoke-RestMethod -Method POST -Uri $ImageURL -Headers $DescribeHeader -Body $InputBlob -ContentType "application/octet-stream"
Write-Output $ImageResults
Write-output $ImageResults.tags


# set subject and mailbody depending on the results
if ($null -eq $ImageResults) {
    Write-Host "no imageresults found"
    $Subject = "Oopsie, something went wrong"
    $MailBody = "An image was commited, but the script didn't give any input"
}
else {
    $DesiredTags = @("Box", "Gift Wrapping", "Ribbon", "Present")
    $GoodGift = $true
    $MissingTags = @()
    $Tags = $ImageResults.tags
    foreach ($Tag in $DesiredTags ) {
        write-host "Tag"
        Write-Host $Tag
        if ($Tags.Name -notcontains $Tag) {
            "no good"
            $GoodGift = $false
            $MissingTags += $Tag
        }
    }
    if ($GoodGift -eq $true) {
        $Subject = "Jay, $($TriggerMetadata.Name) has been well wrapped!"
        $MailBody = "Thank you for all the hard work!"
    }
    else {
        $Subject = "Oh no, $($TriggerMetadata.Name) isn't wrapped right."
        $MailBody = "You have the following tags:$($Tags.name), but are missing: $MissingTags"
    }
}

# Create a body for sendgrid
$Body = @{
    "personalizations" = @(
        @{
            "to"      = @(
                @{
                    "email" = $ENV:receivemail
                    "name"  = "Wrapping crew"
                }
            )
            "subject" = $Subject
        }
    )
    "content"          = @(
        @{
            "type"  = "text/plain"
            "value" = $MailBody
        }
    )
    "from"             = @{
        "email" = $ENV:sendermail
        "name"  = "Barbara Forbes"
    }
}

$BodyJson = $Body | ConvertTo-Json -Depth 5
$Header = @{
    "authorization" = "Bearer $ENV:sendgridKey"
}
#send the mail through Sendgrid
Invoke-RestMethod -Method POST -Uri "https://api.sendgrid.com/v3/mail/send" -Headers $Header -ContentType application/json -Body $BodyJson
