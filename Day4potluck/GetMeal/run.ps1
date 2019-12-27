using namespace System.Net

<#
.SYNOPSIS
    This Azure Function App Gets the entries in a CosmosDB database and outputs them in an object
.DESCRIPTION
    When calling the function, the values of a CosmosDB are returned in a JSON object
.EXAMPLE
    Invoke-RestMethod -Method POST -Uri "https://4besday4.azurewebsites.net/api/GetMeal"
.INPUTS
    Only accepts GET method
.OUTPUTS
    A JSON object with the entries under the data member
.NOTES
    This is an Azure Function App, originally made for 25DaysofServerless.com
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $mealdbin )

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

Write-Output "mealdb = $mealdbin"

# Create an object that will be returned (as a json)
$Return = New-Object PSObject –Property @{
    "Success" = '$true'
    "Message" = "$($mealdbin.Count) objects have been found"
}

# add thatvalues to the return
$Return | Add-Member -MemberType NoteProperty -Name "data" -Value ($mealdbin | Select-Object Cook, Meal)

#Give it back as an HTTP-object
Push-OutputBinding -Name Response -Value (@{
        StatusCode = [HttpStatusCode]::OK
        Body       = ($Return | ConvertTo-JSON)
    })