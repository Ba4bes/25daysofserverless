using namespace System.Net

<#
.SYNOPSIS
    This Azure Function App takes input (a cook and a meal) through a http request and puts it as an object in a cosmosDB
.DESCRIPTION
    This Azure Function App takes input through a http request and puts it as an object in a cosmosDB.
    It returns a http-response to the requester to confirm the input.
.EXAMPLE
    $Body = @{
        Cook: "Harry",
        Meal: "Candy"
    }
    Invoke-RestMethod -Method POST -Uri "https://4besday4.azurewebsites.net/api/AddMeal" -Body ( $Body | ConvertTo-Json ) -ContentType application/json
.INPUTS
    Cook: the name of the cook. Should be unique. If the Cook already exists, the meal will be changed.
    Meal: The meal this cook will bring
.OUTPUTS
    The cook and meal are send to an Azure CosmosDB
    A http response is send.
.NOTES
    This is an Azure Function App, originally made for 25DaysofServerless.com
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $mealdbin)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Set the variables based on a query or a body.
if ($Request.Body) {
    Write-Output "Bodyloop is hit"
    $Cook = $Request.Body.Cook
    $Meal = $Request.Body.Meal
}
else {
    Write-Output "Queryloop is hit"
    $Cook = $Request.Query.Cook
    $Meal = $Request.Query.Meal
}

# Check if a value has been given for the cook. If not, give back an error
if ($null -eq $Cook) {
    $status = [HttpStatusCode]::BadRequest
    $body = "I'm sorry, I did not get that"

}
else {
    write-output 'Cook: ' $Cook
    write-output 'Meal: ' $Meal

    # Create a function for the database-entry, that can be called on later
    Function New-DatabaseEntry {
        #Create an object to write to the database.
        $Mealobject = [PSCustomObject]@{
            id   = $Cook
            Cook = $Cook
            Meal = $Meal
        }
        # Create the output for the HTTP response
        $Script:status = [HttpStatusCode]::OK
        $Script:body = "Thank you $Cook!, your meal $Meal has been added"
        # Push the object to the CosmosDB.
        Push-OutputBinding -Name mealdbout -Value $Mealobject
    }
    # Check what method was used
    Switch ($Request.Method) {
        "POST" {
            Write-output "Method is Post"
            # An error should be returned if the entry already exists
            if (($mealdbin.id) -contains $Cook) {
                $status = [HttpStatusCode]::BadRequest
                $body = "Someone with the name $Cook already exists"
            }
            else {
                New-DatabaseEntry
            }
        }
        "PATCH" {
            Write-output "Method is Patch"
            New-DatabaseEntry
        }
        default {
            # Other methods are not supported and should return that
            $status = [HttpStatusCode]::BadRequest
            $body = "This method is not supported"
        }
    }
}

# Give an http response to show if the push to database succeeded
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $status
        Body       = $body
    })