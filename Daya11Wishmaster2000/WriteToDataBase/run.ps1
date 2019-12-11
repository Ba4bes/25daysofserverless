using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)
# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
Write-Output "Request:"
$Request

Write-Output "Metadata"
$TriggerMetadata

$ChildsName = $Request.Query.ChildsName
$Address = $Request.Query.Address
$Wish = $Request.Query.Wish
$Present = $Request.Query.Present

$ChildObject = @{
    id         = $ChildsName
    ChildsName = $ChildsName
    Address    = $Address
    Wish       = $Wish
    Present    = $Present
}

Write-Output 'ChildObject'
$ChildObject
if ($ChildObject.ChildsName) {
    $status = [HttpStatusCode]::OK
    $body = "Thank you $($ChildObject.ChildsName)!, your message has been received"

    Push-OutputBinding -Name Documents -Value $ChildObject
}
else {
    $status = [HttpStatusCode]::BadRequest
    $body = "I'm sorry, I did not get that"
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $status
        Body       = $body
    })
