using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $dbin)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
$id = $Request.Query.ID
if (-not $id) {
    $status = [HttpStatusCode]::BadRequest
    $body = "I need an ID"
}
else {
    $RegObject = [pscustomobject]@{
        id = $Request.Query.id
    }
    $RegObjectdatabase = $dbin | Where-Object { $_.id -eq $id }
    foreach ($member in $RegObjectdatabase.getenumerator()) {
        write-output "member 1" $member
        if ($member -notlike "_*" -and $member -notlike "id") {
            $RegObject | Add-Member -MemberType NoteProperty $member.key -Value $member.value
        }

    }
    foreach ($item in ($Request.Query).getenumerator()) {
        $RegObject | Add-Member -MemberType NoteProperty -Name $item.Key -Value $item.Value -Force
        Write-output "Item1"
        Write-output 'Itemkey' $Item.Key
        write-output 'itemvalue' $item.Value

    }
    $status = [HttpStatusCode]::OK
    $body = "Registry with ID $($Regobject.id) has changed. New Value: $RegObject"
    Push-OutputBinding -Name dbout -Value $Regobject

}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = $status
        ContentType = 'text/html'
        Body        = $body
    })