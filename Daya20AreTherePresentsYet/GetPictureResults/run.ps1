# Input bindings are passed in via param block.
param([byte[]]$InputBlob, $TriggerMetadata)

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
    $Tags = $ImageResults.tags
    if ($tags.name -contains "present") {
        Write-Host "a present!"
        $Subject = "Jay, a present has arived!"
        $MailBody = "Quick come find your present!"

        # Create a body for sendgrid
        $Body = @{
            "personalizations" = @(
                @{
                    "to"      = @(
                        @{
                            "email" = $ENV:receivemail
                            "name"  = "Happy present receiver"
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
    }
    Write-output "no present."
    $Tags.name
}
