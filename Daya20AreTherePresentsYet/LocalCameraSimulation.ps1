# This script is made to simulate a camera. It uploads images to a storage account by using a IOT hub to get the SASkey
using namespace System.Net

$header = @{
    Authorization = "SharedAccessSignature [IOT-saskey]"
}


$Path = "C:\Images\"
$Images = Get-Childitem  $Path
foreach ($Image in $Images) {
    $Name = $Image.Name
    $File = $Path + $Name

    $URL = "https://HUB.azure-devices.net/devices/Compressor/files?api-version=2018-06-30"
    $body = @{
        "blobName" = $Name
    }
    $SaMetaData = Invoke-RestMethod -Method POST -Uri $URL -Body ($Body | ConvertTo-Json) -Headers $header -ContentType "application/json"

    $uri = "https://$($SAMetadata.Hostname)/$($SAMetadata.containerName)/$($SAMetadata.blobName)$($SaMetadata.sasToken)"
    #Define required Headers
    $headers = @{
        'x-ms-blob-type' = 'BlockBlob'
    }

    #Upload File...
    Invoke-RestMethod -Uri $uri -Method PUT -Headers $headers -InFile $file
    #############################
    Write-output "$Name upload done"
    Start-Sleep 30

}

