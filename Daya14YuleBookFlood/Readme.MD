# 25daysofserverless Day 14

## Azure Function App

Lets try SignalR again!
I must say, I read a lot to websites that really lay this process out step-by-step.
For example:

<https://github.com/Azure-Samples/signalr-service-quickstart-serverless-chat>

<https://dfinke.github.io/powershell,%20azure%20functions,%20signalr/2019/05/12/Build-real-time-Apps-with-a-PowerShell-Azure-Function-And-SignalR.html>

<https://dev.to/azure/how-you-can-learn-to-build-real-time-web-apps-using-net-core-c-and-azure-signalr-service-and-some-javascript-27b0>

and

<https://dev.to/mattbrailsford/auto-scaling-azures-signalr-service-via-powershell-function-45j5>

One thing that really none of these blogs mention, is the changes in CORS you have to make in the function app once it is deployed.

So that took some time :).

My site is running on a web app, connecting to a function app and SignalR.

Visit it on <http://4besday14chat.azurewebsites.net>

The site doesn't scale, because I want to safe costs in my azure tenant.

## Call the function

Open this in the browser:  <http://4besday14chat.azurewebsites.net>

## The Challenge

### YULE BOOK FLOOD

*Saturday, 14 December*
It's that time of the year here in Reykjavík, Iceland: Jólabókaflóð!

For the "Yule Book Flood", instead of just giving gifts to each other, most Icelanders give each other books on Christmas Eve and then spend the evening reading!

Joon is too much of a social butterfly to read by himself all alone, though. While he and his friends are all sitting in their own homes reading, he wants to be able to talk to them about the various books they're enjoying!

Your challenge for today is to build Joon a real-time online chat service. It needs to be able to scale: if Joon's friends invite their friends, and they invite their friends, that could be a whole lot of people chatting about books! He and his friends should be able to log onto a web app where they can pick a username (and maybe even an avatar) and send chat messages that get sent in real-time to everyone else who's in the chat room.

Hint: you might want to look into Azure SignalR Service!

## More information

 This app is running on an Azure Function App with PowerShell. Want to find out more about creating your own? Click [here]('https://4bes.nl/MSIgnite')

Barbara Forbes  
[@Ba4bes](https://www.twitter.com/ba4bes)  
[4bes.nl](https://4bes.nl)
