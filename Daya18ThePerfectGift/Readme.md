# 25daysofserverless Day 18

## Azure Function App

This Function App takes a picture from the a storage blob and connects to Computer vision to get the tags.

There was not defined what the output should be. But I was looking for a reason to try Sendgrid, so I connected the app to Sendgrid so it can send emails.

![screenshot](./example.png)

## The Challenge

### Wrapping the perfect gift

*Wednesday, 18 December*  
Santa's Elves are wrapping all of this year's gifts and they're looking for an automated way to confirm that each has been wrapped properly. According to Santa, each present must be wrapped according to the following rules:

Placed in a box
Box is wrapped
A bow / ribbon placed on top
Luckily Azure Cognitive Services offers an easy way to do this using the Computer Vision API!

Using Santa's example of a perfectly wrapped gift, the Computer Vision API confirms the following Tags:

[x] Box
[x] Gift Wrapping
[x] Ribbon
[x] Present

## More information

 This app is running on an Azure Function App with PowerShell. Want to find out more about creating your own? Click [here]('https://4bes.nl/MSIgnite')

Barbara Forbes  
[@Ba4bes](https://www.twitter.com/ba4bes)  
[4bes.nl](https://4bes.nl)
