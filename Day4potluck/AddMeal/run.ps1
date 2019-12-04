using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
$Cook = $request.Query.Cook
$Meal = $Request.Query.Meal

write-output 'cook' $Cook
write-output 'meal' $Meal

$Mealobject = @{
    id   = $Cook
    Cook = $Cook
    Meal = $Meal
}

Write-Output 'mealobject' $Mealobject
if ($cook -and $Meal) {
    $status = [HttpStatusCode]::OK
    $body = "Thank you $Cook!, your meal $Meal has been added"

    Push-OutputBinding -Name mealdb -Value $Mealobject
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