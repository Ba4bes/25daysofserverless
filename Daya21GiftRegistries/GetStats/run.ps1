using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $dbin)

#Stats to get the following stats: total registries (open or closed) and total items in the registry list (an aggregate across all registries)
$TotalRegistries = $dbin.count
$ItemCount = @{ }
Write-Output "get db count" $dbin.count
foreach ($item in $dbin) {
    write-output $item.id
    write-output "itemcount" $item.count
    $ItemCount.add($item.id, $item.count)
}
$closed = $dbin | Where-Object { $_.Status -eq 'closed' }
$open = $dbin | Where-Object { $_.Status -eq 'open' }
Write-Output "closed" $closed.count
Write-Output "open" $open.count
$Output = [PSCustomObject]@{
    TotalRegistries = $TotalRegistries
    ClosedItems     = $closed.Count
    OpenItems       = $open.Count
    ItemCount       = $ItemCount
}
$status = [HttpStatusCode]::OK
$body = $Output


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $status
        Body       = $body
    })