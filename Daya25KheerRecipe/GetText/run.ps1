# Input bindings are passed in via param block.
param([byte[]] $InputBlob, $TriggerMetadata)

# Write out the blob name and size to the information log.
Write-Host "PowerShell Blob trigger function Processed blob! Name: $($TriggerMetadata.Name) Size: $($InputBlob.Length) bytes"

$Header = @{
    "Ocp-Apim-Subscription-Key" = "$ENV:SubscriptionKey"
    "Content-Type"              = "audio/wav"
    codecs                      = "audio/pcm"
    samplerate                  = 16000
}


$URL = "https://westeurope.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=en-US"

$Result = Invoke-RestMethod -Method POST -Headers $Header -Uri $URL -Body $InputBlob
Write-Output $Result

Push-OutputBinding -Name OutputBlob -Value $Result.DisplayText
