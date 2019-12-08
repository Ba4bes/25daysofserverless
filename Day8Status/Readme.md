# 25daysofserverless Day 8

## Process

I really really really really tried to get a PowerShell Function App to talk to SignalR. I just couldn't get it. After a while I decided to go for a different route.

This is a PowerShell Function App.
The function SetStatus is an API for the elfs to set the current status.
The function Front shows a website with the current status and when it was set.

To get some sort of live updates there, I have set the webpage to reload every 30 seconds.

![image](.\html.PNG)

## The Challenge

### Status update

*Sunday 8 December 2019*  
It's December 8th and Santa and his team are hard at work preparing for the big night, including replacing many of the servers and applications that run the reindeer guidance and delivery systems.

If something goes wrong with any part of that critical system, they need a way to report the status of disruptions to everyone involved in a successful Christmas morning.

They need a basic version of what you can find at status.azure.com.

During these tense disruptions, elves are actively diagnosing and working as quickly as possible to bring important systems back online. While response and remediation efforts are underway, it's important everyone who has a stake in the successful delivery of gifts stay "in the know".

We are tasked with building a method for Santa and his team to communicate the current status of service disruptions to a global audience. A "Status Page" solution.

Challenge
Your challenge is to create a simple solution that helps inform elves and helpers all over the world when there is a problem with Santa's Reindeer Guidance & Delivery System - a "Status Page" to inform everyone what is known, what is being done, and when to expect additional information.

Tips
There are many approaches to broadcasting critical information like this. For simplicity, we might consider keeping the team informed by setting and broadcasting the current "Status" as 1 of 3 states:

Open
Closed
Ongoing (or update)
The "Open" state means we have a problem (Service Disruption / Offline). The "Closed" state means our problem is resolved (Service Restored / Online). The "Ongoing" state means we are still investigating (Standby for more updates).

## More information

 This site is running on an Azure Function App with PowerShell. Want to find out more about creating your own? Click [here]('https://4bes.nl/MSIgnite')

Barbara Forbes  
@Ba4bes  
[4bes.nl](https://4bes.nl)  

![PowerShell Function App](https://4bes.nl/wp-content/uploads/2019/11/PSFunctionApp-300x252.png)
