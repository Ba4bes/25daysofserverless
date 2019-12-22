# 25daysofserverless Day 22

## Azure Function App

Yay, a PowerShell function app!
With this app, every keyvault in the subscription is backed up to a storage account.
That function runs every day on a schedule.
The RestoreKeyVault function can be called through a webhook. It creates new keyvaults and restores the secrets.
The Retention function checks the files in the storage accounts and removes the ones that are more than 90 days old.

## The Challenge

### Winter Solstice

*Sunday, 22 December*  
Welcome to Korea in this festive season! Today is Winter Solstice, which means grim reapers are wandering around in search of young kids' souls to steal. But there's a way to keep the children safe: the reapers can't find any child who eats red-bean porridge before going to sleep!

Oh no! Cheol-soo missed the porridge tonight, and is in danger to get caught by the grim reaper! His best friend Young-hee locked him in a safe place until sunrise, and stored the digital key to the smart lock in Azure Key Vault.

The grim reaper is annoyed that they're thwarted, though, and is trying to destroy the Key Vault to trap Cheol-soo in the safe room! Young-hee needs to figure out how to back up and restore the Key Vault before the Grim Reaper destroys it, or else Cheol-soo will be stuck in there forever!

Build a system that can back up and restore a secure key vault. If you're using Azure Key Vault, you may want to investigate Blob Storage restoration via Managed Identity.

## More information

 This app is running on an Azure Function App with PowerShell. Want to find out more about creating your own? Click [here]('https://4bes.nl/MSIgnite')

Barbara Forbes  
[@Ba4bes](https://www.twitter.com/ba4bes)  
[4bes.nl](https://4bes.nl)
