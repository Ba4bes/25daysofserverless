using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Simulate the 10% failure rate by selecting 1 random number that stands for swearing.
$Swearstatus = Get-Random -Minimum 0 -Maximum 10
If ($Swearstatus -eq 2) {
    $Status = [HttpStatusCode]::BadRequest
    $Body = "SWEARING OCCURED"
}
Else {
    $Status = [HttpStatusCode]::OK
    $Body = "all good"
}


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = $Status
        Body        = $Body
    })