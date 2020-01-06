<#
    .SYNOPSIS
    This function creates a onetime runbookschedule and registers it to a runbook.
    .DESCRIPTION
    First the input is filtered through Regex to get a date and time.
    A unique name for the schedule is created with a number.
    This name is used for a new schedule.
    The schedule will be registered to a runbook.
    After that the result is send to Teams
    .PARAMETER Message
    The message that contains the date
    .PARAMETER Parameters
    The parameters that need to be passed to the runbook.
    .EXAMPLE
    New-RunbookSchedule -Message "/Schedule send an altert at 10PM"
    .EXAMPLE
    New-RunbookSchedule -Message "/Schedule send an altert at 08/02/2020"
    .NOTES
    This is an Automation account runbook, originally made for 25DaysofServerless.com
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory = $false)]
    [String]$Message
)
#Requires -modules AzureRM

# Set the Variables
$AutomationAccount = "ForbesDay6"
$AutomationAccountRG = "4besDay6"
$RunbookName = "New-TeamsMessage"
$Fail = $False
$ResultDate = (Get-Date)
# Set your timezone compared to UTC
$Timezone = "+1:00"


# Check the Connection. Send a failure if it fails
$connectionName = "AzureRunAsConnection"
try {
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint
}
catch {
    $Fail = $True
    if (!$servicePrincipalConnection) {
        $ErrorMessage = "Connection $connectionName not found."
        Write-Error $ErrorMessage
    }
    else {
        Write-Error -Message $_.Exception
        Write-Error $_.Exception
    }
}

# Remove the /schedule portion from the output
$Message = $Message -replace '/schedule'
Write-Output Message: $Message

$CurrentDate = Get-Date
Write-Output "Currentdate" $CurrentDate

# find a string in the message to create the ResultDate
switch -Regex ($Message) {
    "\d{8}" {
        $FormatString = "ddMMyyyy"

    }
    "(?i)tomorrow" {
        $ResultDate = $CurrentDate.AddDays(1)
        $message = $message -replace "tomorrow"
    }
    "(?i)Next week" {
        $ResultDate = $CurrentDate.AddDays(7)
        $message = $message -replace "next week"
    }
    "\d{1,2}[^a-z0-9]\d{1,2}[^a-z0-9]\d{2,4}[ ]*[^a-z0-9]*\d*" { $ResultDate = Get-Date -Date $Matches[0] }
    "\d{1,2}(PM|AM)" { $ResultDate = Get-Date -Date $Matches[0] }
    Default { Write-Output "No match found with regex" }
}

# If the string wasn't found, it will be tried throught parseExact
if ([string]::IsNullOrEmpty($ResultDate) ) {
    Write-Output "Try to fix empty resultdate"
    Try {
        $ResultDate = [datetime]::ParseExact($date, $FormatString, $null)
    }
    Catch {
        # If it fails, set the variable
        $Fail = $true
    }
}


Write-Output "Resultdate" $ResultDate

# Create the schedule. A schedulename needs to be unique in the automation account.
$i = 0
do {
    # Add to $i until a schedulename is found that does not exist.
    $i++
    $UniqueName = "$ScheduleName $i"

    # Check if the schedule exists
    $Parameters = @{
        Name                  = $UniqueName
        ResourceGroupName     = $AutomationAccountRG
        AutomationAccountName = $AutomationAccount
    }
    $ScheduleCheck = Get-AzureRmAutomationSchedule @Parameters -ErrorAction SilentlyContinue
}
while ($ScheduleCheck)
Write-verbose "New Schedulename: $UniqueName"

# Create a new schedule
Try {
    $Parameters = @{
        Name                  = $UniqueName
        ResourceGroupName     = $AutomationAccountRG
        AutomationAccountName = $AutomationAccount
        StartTime             = "$ResultDate" + "$Timezone"
    }
    New-AzureRmAutomationSchedule @Parameters -OneTime -ErrorAction Stop
    Write-Output "Schedule $UniqueName has been created"

}
Catch {
    $Fail = $true
    Write-Error $_
    Write-Error "Schedule $UniqueName could not be created."
    return
}
# Register the schedule to the runbook
Try {
    $Parameters = @{
        ResourceGroupName     = $AutomationAccountRG
        AutomationAccountName = $AutomationAccount
        RunbookName           = $RunbookName
        ScheduleName          = $UniqueName
        Parameters            = @{Message = $Message }
    }
    Register-AzureRmAutomationScheduledRunbook @Parameters -ErrorAction Stop
    Write-Output "Schedule $UniqueName registered to $RunbookName"

}
Catch {
    $Fail = $true
    Write-Error $_
    Write-Error "Schedule $UniqueName could not be registered."
    return
}

#Create an object to retrun to teams
if ($Fail -eq $true) {
    $JSONobject = @{
        text = "Something went wrong with your schedule"
    }
}
else {
    $JSONobject = @{
        text = "Your schedule has been set for $ResultDate"
    }
}

# Send the result to the teams channel
$URL = "https://outlook.office.com/webhook/123456-123-123-123-12345678@123456-123-123-123-12345678/IncomingWebhook/123456-123-123-123-12345678/c123456-123-123-123-12345678"
Invoke-RestMethod -Method POST -Uri $URL -ContentType "Application/JSON" -Body ($JSONobject | ConvertTo-Json) -ContentType "Application/JSON"




