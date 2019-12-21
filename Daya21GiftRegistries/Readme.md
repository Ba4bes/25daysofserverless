# 25daysofserverless Day 21

## Azure Function App

Still not possible to create durable apps in Powershell :(. So I connected the cosmosdb again.
The functions AddRegistry, FinishRegistry and OpenRegistry work with the registries in de database.
WIth GetSTats you can get the statistics of the database.

I use SetClosedTimer for the automatic closing. It is a bit of a workaround, is simply responds to a CosmosDBtrigger, sets a timer and then calls finishRegistry

## The Challenge

### Last Minute Gift Registry

*Saturday, 21 December*  
Oh no! The 🧝‍♀️🧝‍♂️ elves are upset. It's almost time to deliver gifts, but a glitch in the North Pole 💈 data center destroyed Santa's master registry list (should have backed it up to the cloud!). As a last minute effort to modernize North Pole operations, the lead developer elf decided to create a set of REST APIs to track gift registries. To create a sense of urgency and ensure the orders can be fulfilled, registries are only available for 5 minutes before they are automatically closed and sent for processing.

For this challenge, create a set of of WebHooks for managing registries. The WebHooks should support the following operations:

Open to create a new registry and return a unique identifier for that registry
Add to add an entry to the registry based on id (any text)
Finish to close a registry based on id
Stats to get the following stats: total registries (open or closed) and total items in the registry list (an aggregate across all registries)
If Finish is not called within 5 minutes after the registry is opened, it should automatically close regardless of whether any items have been added.

Bonus: Although not required for this challenge, it would be great to have a Peek WebHook to look at a registry and show if it is open or closed and what the contents are.
## More information

 This app is running on an Azure Function App with PowerShell. Want to find out more about creating your own? Click [here]('https://4bes.nl/MSIgnite')

Barbara Forbes  
[@Ba4bes](https://www.twitter.com/ba4bes)  
[4bes.nl](https://4bes.nl)
