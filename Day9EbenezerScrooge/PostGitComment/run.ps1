using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Output $Request.Body

$body = $request.Body
$username = $body.issue.user.login
if ($body.action -eq "Opened"){
   $outBody = " :christmas_tree: Hello $username, Thank you for your message :sparkles: :smiley:. "


$body.issue.title
$body.issue.user
$body.action

[string]$token = $ENV:GHtoken
[string]$user = $ENV:GHUser
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $User, $Token)))
$Header = @{
    Authorization = ("Basic {0}" -f $base64AuthInfo)
}
write-output "body" $outbody
$bodyjson = (@{body=$outBody} | ConvertTo-Json)
Write-output "bodyJson" $bodyjson
Invoke-RestMethod -Headers $Header -Method POST -Uri "$($body.issue.url)/comments" -body $bodyjson -ContentType "application/JSON"
}


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = "OK"
    Body = $body
})
