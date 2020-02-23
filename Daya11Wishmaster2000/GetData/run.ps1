using namespace System.Net
<#
.SYNOPSIS
    This Azure Function App Gets the entries in a CosmosDB database and outputs them as an HTML table
.DESCRIPTION
    When calling the function, the values of a CosmosDB are returned as an HTML output
.INPUTS
    Only accepts GET method, should be called from a browser
.OUTPUTS
    HTML table with entries
.NOTES
    This is an Azure Function App, originally made for 25DaysofServerless.com
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $Children )

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

Write-Output "childrendb = $Children"

# Create a HTML table that will be returned
$HTMLHeader = @"
<style>
BODY {font-family:verdana;}
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; padding: 5px; background-color: #d1c3cd;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black; padding: 5px}
</style>
"@
$ChildrenHTML = $HTMLHeader + (($Children | select-object  ChildsName, Address, Wish , Present ) | ConvertTo-Html)

# Give it back as an HTML Page
Push-OutputBinding -Name Response -Value (@{
        StatusCode  = "ok"
        ContentType = "text/html"
        Body        = $ChildrenHTML
    })