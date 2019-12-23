# 25daysofserverless Day 23

## Azure Function App

So the function app is simple. It selects a random number between 0 and 10. If that number happens to be two, a bad result is generated. This way I simulated the swaering happening 10 % of the time.

This function is called through a webhook. To alert the wifes of it going wrong, I used Azure Alerts with the following query:
```
requests
| where cloud_RoleName =~ '4besDay23' and operation_Name == 'CursingStatus' and resultCode != 200
| project timestamp , resultCode
```

## The Challenge

### Chasse Galerie

*Monday, 23 December*  
Ages ago, workers of a remote timber camp in Quebec wanted to meet their wives for the night of Christmas. The problem was that they needed to work the next day and their homes were hundreds of leagues away. They made a pact with the devil to run the Chasse-Galerie so that their canoe could fly through the air.

A flying canoe would surely allow them to get home and back before the night was over! However, as part of the deal, the workers are not allowed to curse or their soul would be claimed by the devil.

On their trip to their home, and back, we need to make sure that their canoe is still operational. Their worried wives will be monitoring if everything is okay. They will need to receive an alert if something happens.

For this scenario, the canoe will need an Health Check endpoint that will return a 200 if everything is okay or throw an exception if a worker has cursed on their voyage. The worker curses 10% of the time.

After that endpoint is up and running, you'll need to build something that can notify the flying lumberjacks' wives if things have gone horribly wrong. One choice might be to use Azure Application Insights.

## More information

 This app is running on an Azure Function App with PowerShell. Want to find out more about creating your own? Click [here]('https://4bes.nl/MSIgnite')

Barbara Forbes  
[@Ba4bes](https://www.twitter.com/ba4bes)  
[4bes.nl](https://4bes.nl)
