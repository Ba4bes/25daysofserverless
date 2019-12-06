<#
    .SYNOPSIS
    This function creates a onetime runbookschedule and registers it to a runbook.
    .DESCRIPTION
    A unique name is created with a parameter and a number.
    This name is used for a new schedule.
    The schedule will be registered to a runbook.
     .PARAMETER AutomationAccount
    The name of the Automation Account where the runbook is and the schedule will be.
    .PARAMETER ScheduleName
    The name for the schedule, which will be used as a prefix.
    .PARAMETER RunbookName
    The name of the runbook that needs to be scheduled.
    .PARAMETER Date
    The date and time the runbook will run.
    .PARAMETER Parameters
    The parameters that need to be passed to the runbook.
    .EXAMPLE
    $Date = (Get-Date).AddDays(5)
    $Parameters = @{
        Parameter = $true
    }
    New-RunbookSchedule -AutomationAccount "Aut01" -ScheduleName "Schedule" -Runbookname "start-script" -Datum $Date -Parameters $parameters
    .NOTES
    Support voor whatif.
    The schedulename will be created by a loop that looks for the lowest name-number-combination not in use.
    #>

[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
Param(
    [Parameter(Mandatory = $true)]
    [string]$Date,
    [Parameter(Mandatory = $false)]
    [String]$Message
)

$Message = $Message -replace "/Schedule", ""
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
    if (!$servicePrincipalConnection) {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    }
    else {
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}
[datetime]$ScheduleDate = (Get-Date)
$date = $date -replace '<.*?>', ' '
$Message = $Message -replace '<.*?>', ' '
switch -Regex ($Date) {
    "(?i).*tomorrow.*" { $ScheduleDate = $ScheduleDate.AddDays(1) }
    "\d{1,2}[^a-z]\d{1,2}[^a-z]\d{2,4}[ ]*[^a-z]*\d*" { $ScheduleDate = [datetime]$Matches[0] }
    "\d{1,2}(PM|AM)" { $ScheduleDate = [datetime]$Matches[0] }
    Default { $Fail = $true }
}
#Workaround for timezone
$ScheduledDate = $ScheduleDate
$AutomationAccount = "ForbesDay6"
$AutomationAccountRG = "4besDay6"
$RunbookName = "New-TeamsMessage"
#Requires -modules AzureRM
# A schedulename needs to be unique in the automation account.
$i = 0
do {
    # Add to $i untill a schedulename is found that does not exist.
    $i++
    $UniqueName = "$ScheduleName $i"

    # Check if the schedule exists
    $ScheduleCheck = Get-AzureRmAutomationSchedule -Name $UniqueName -ResourceGroupName $AutomationAccountRG -AutomationAccountName $AutomationAccount -ErrorAction SilentlyContinue
}
while ($ScheduleCheck)
Write-verbose "New Schedulename: $UniqueName"
# Create a new schedule
Try {
    if ($PSCmdlet.ShouldProcess(
            ("New Schedule {0} will be created for {1}" -f $UniqueName, $Date),
            ("Do you want to create the schedule {0} for date {1}?" -f $UniqueName, $Date),
            "Create Schedule"
        )
    ) {
        New-AzureRmAutomationSchedule -Name $UniqueName -ResourceGroupName $AutomationAccountRG -AutomationAccountName $AutomationAccount -StartTime "$ScheduleDate+01:00" -OneTime -ErrorAction Stop
        Write-Output "Schedule $UniqueName has been created"
    }
}
Catch {
    $fail = $true
    Write-Error $_
    Write-Error "Schedule $UniqueName could not be created."
    return
}
# Register the schedule to the runbook
Try {
    if ($PSCmdlet.ShouldProcess(
            ("Schedule {0} will be registered  to runbook  {1}" -f $UniqueName, $RunbookName),
            ("Do you want to register {0} tor runbook {1}?" -f $UniqueName, $RunbookName),
            "Schedule koppelen")) {
        Register-AzureRmAutomationScheduledRunbook -ResourceGroupName $AutomationAccountRG -AutomationAccountName $AutomationAccount -RunbookName $RunbookName -ScheduleName $UniqueName -Parameters @{Message = $Message } -ErrorAction Stop
        Write-Output "Schedule $UniqueName registered to $RunbookName"
    }
}
Catch {
    $fail = $true
    Write-Error $_
    Write-Error "Schedule $UniqueName could not be registered."
    return
}

if ($fail -eq $true) {
    $jsonobject = @{
        text = "Something went wrong with your schedule"
    }
}
else {
    $jsonobject = @{
        text = "Your schedule has been set for $ScheduleDate"
    }
}

Invoke-RestMethod -Method POST -Uri "https://outlook.office.com/webhook/123456-123-123-123-12345678@123456-123-123-123-12345678/IncomingWebhook/123456-123-123-123-12345678/c123456-123-123-123-12345678" -ContentType "Application/JSON" -Body ($JSONobject | ConvertTo-Json)

