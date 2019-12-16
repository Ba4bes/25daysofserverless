# Function App Get-AzRunningVMs

The app generates an simple webpage that at shows all running VMs in a subscription.

![Image](https://4bes.nl/wp-content/uploads/2019/06/FunctionApp9b.png)

## Deployment

The arm template only deploys the App itself, not the code.
For a complete guide on deployment, please see the following blog:

 [4bes.nl - Manual setup: Configure Azure Functions for PowerShell in the portal](https://4bes.nl/2019/06/12/configure-azure-functions-for-powershell-in-the-portal/)

[4bes.nl - Automatic setup: Deploy Azure Functions for PowerShell with Azure DevOps](https://4bes.nl/2019/06/16/deploy-azure-functions-for-powershell-with-azure-devops/)


## Available Components

- **Deployment**
  This folder contains an ARM template to deploy the app, and a PowerShell script that sets the apps permissions
- **FunctionApp**
  This is the code for the Funtion app itself
- **Tests**
  Pester tests for the PowerShell script inside the function app
  Azure-pipelines.yml
  a pipeline to test and deploy this app through Azure DevOps
  - **Set-Permissions.ps1**
  For manual deployment: a script to set the correct permissions
