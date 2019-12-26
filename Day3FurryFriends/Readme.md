# 25daysofserverless Day 3

This script has been cleaned up since the original submission for the challenge.

[Original submission](https://github.com/Ba4bes/25daysofserverless/tree/e588479bfae9129678ee3859415847667c5b40af)

## Call the function

The function will be triggered by a Github web hook. It takes the input and checks the files for png-extensions.
The Web Hook settings on Github are like this:

![github screenshot](.\PNGs\GitHubWebHook.PNG)

I have taken the easy way with the output and created a message in a storage queue, as I already knew how it works.

![storage screenshot](.\PNGs\messagequeue.PNG)

## The Challenge

### Secret Santa's Furry Friends

*Tuesday 3 December 2019*  
'Tis the season for gift giving! Here at Microsoft HQ in Redmond, we're excited for our annual Secret Santa gift swap! Each employee who chooses to participate is assigned another coworker to give a gift to. Rather than put a price limit on gifts, though, Satya has decided that this year everyone is just going to send their favorite cute animal picture. To make sure people can't easily figure out who their Secret Santa is, he wants to make sure that all of the photos are stored in the same format (png) and are made available from a single database.

For this challenge, create a web service that gets called everytime a commit or push is made to a Github repository. If the commit has a file ending with .png, your service should take the URL to the image from Github and store it in whatever database you like.

## More information

 This webhook is running on an Azure Function App with PowerShell. Want to find out more about creating your own? Click [here]('https://4bes.nl/MSIgnite')

Barbara Forbes  
@Ba4bes  
[4bes.nl](https://4bes.nl)  

![PowerShell Function App](https://4bes.nl/wp-content/uploads/2019/11/PSFunctionApp-300x252.png)
