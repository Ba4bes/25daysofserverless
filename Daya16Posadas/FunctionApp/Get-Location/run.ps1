using namespace System.Net

# Input bindings are passed in via param block.
param($Request)
$AlldataHTML = (Import-CSV "$PWD\DeployResource\Get-Location/Locations.CSV") | ConvertTo-Html

    $HTML = @"
<style>
BODY {font-family:verdana;}
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; padding: 5px; background-color: #d1c3cd;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black; padding: 5px}
</style>
$AlldataHTML
"@

Push-OutputBinding -Name Response -Value (@{
        StatusCode  = "ok"
        ContentType = "text/html"
        Body        = $HTML
    })



