using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# List the possible outcomeoptions in an array
$OutcomeOptions = @(
    " נ"
    " ג"
    " ה"
)

# Create an object that will be returned (as a json)
$Return = New-Object PSObject –Property @{
    "Success" = '$true'
    "Message" = "The dreidel is done spinning"
}

# Get a random value from the outcomeoptions
$Result = $OutcomeOptions | Get-Random -Count 1

# add thatvalues to the return
$Return | Add-Member -MemberType NoteProperty -Name "data" -Value @{"Result" = $Result }
Write-Host "Return: $Return"

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = ($Return | ConvertTo-Json)
    })
