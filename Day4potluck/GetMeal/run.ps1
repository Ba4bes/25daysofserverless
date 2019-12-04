using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $mealdb )

write-output "mealdb = $mealdb"


$MealJSON = ($mealdb | select-object Cook, Meal) | ConvertTo-Json

Push-OutputBinding -Name Response -Value (@{
    StatusCode  = "ok"
    Body        = $MealJSON
})