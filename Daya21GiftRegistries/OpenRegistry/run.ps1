using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

$Regobject = [PSCustomObject]@{
    id     = (New-Guid).Guid
    Status = "Open"
}
foreach ($item in ($Request.Query).getenumerator()) {
    $RegObject | Add-Member -MemberType NoteProperty -Name $item.Key -Value $item.Value -Force
    Write-output "Item1"
    Write-output $Item
}

Write-Output 'RegObject' $RegObject
if ($Regobject) {
    $status = [HttpStatusCode]::OK
    $body = "<h1> Registry with ID $($Regobject.id) has been created. </h1>"
    Push-OutputBinding -Name dbout -Value $Regobject

    # trigger logic app
    Write-Output $Regobject
 #   Invoke-RestMethod -Method POST -uri "$ENV:LogicAppUri&id=$id"
}
else {
    $status = [HttpStatusCode]::BadRequest
    $body = "I'm sorry, I did not get that"
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = $status
        ContentType = 'text/html'
        Body        = $body
    })