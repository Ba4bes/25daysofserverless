using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $Children )

write-output "mealdb = $Children"


$ChildrenHTML = ($Children | select-object  ChildsName, Address, Wish ,Present ) | ConvertTo-Html

Push-OutputBinding -Name Response -Value (@{
    StatusCode  = "ok"
    ContentType = "text/html"
    Body        = $ChildrenHTML
})