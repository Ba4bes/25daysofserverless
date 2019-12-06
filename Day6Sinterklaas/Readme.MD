# 25daysofserverless Day 5

![.\teams-channel.PNG](.\teams-channel.PNG)
## Process

Well the first issue was very clear: Durable functions are not available yet for PowerShell in Function Apps

I spend a lot of time fooling around in creating a function from a function. I believe it can be done, but it was taking to much time.

So I went a different route. Scheduling can actually be done with an Azure Automation Account. I had done this before and written blogposts about it. 

So I copied my own script from [https://4bes.nl/2019/02/08/script-create-linked-runbookschedules-with-powershell/](here) and changed it for this situation.
I allowed this schedule to start a runbook that posts a team message as my communication channel.

To give Teams an option to be a trigger, I have used Logic Apps. I actually had a [https://4bes.nl/2019/02/18/using-logic-apps-trigger-an-azure-runbook-with-an-office365-calendar-appointment/](blogpost) for this as well.

The extra challenge was the datetime element. I couldn't use the option in the challenge, so I started writing a PowerShell option. Time is short so I have put a few options in there. So this is great for the feature.

And then I realized Azure has a different timezone... I was running out of time so I did an ugly workaround, I did it hardcoded for my own timezone.

So some workarounds, but at least it is working

## The Challenge

### Sinterklaas

*Friday 6 December 2019*
Happy St. Nicholas Day! Here in the Styrian region of Austria, it's said that today is the day that St. Nicholas goes around handing out presents, while his evil counterpart Krampus whips those who have been naughty. These days, that mostly results in people giving each other bundles of ruten, bundles of birch twigs that have been painted gold.

You're supposed to hang up these ruten year-round to remind children to be good, but of course today's children don't spend much more time in online chats than sitting in front of the fireplace. Let's write a reminder tool using serverless tech that lets Austrian children set reminders to do good deeds in their favorite chat app!

Build a chat integration for your favorite chat service (e.g. Discord or Slack) that lets you schedule tasks using natural language (e.g. /schedule volunteer at the senior citizens' center tomorrow at 11:00). You should be able to get a confirmation that your event has been scheduled, and then get a notification at the correct time.

## More information

# Useful links

Barbara Forbes  
@Ba4bes  
[4bes.nl](https://4bes.nl)  

![PowerShell Function App](https://4bes.nl/wp-content/uploads/2019/11/PSFunctionApp-300x252.png)
