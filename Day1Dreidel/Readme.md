# 25daysofserverless Day 1

## Call the function

The function can be called as an API, for example with PowerShell

```PowerShell
Invoke-RestMethod -Method GET -URI "https://4besday1.azurewebsites.net/api/spinthedreidel"
```

## The Challenge

### Spin the Dreidel!

*Sunday, 1 December 2019*  
Your first stop is Tel Aviv, Israel, where everybody is concerned about Hanukkah! Not only have all the dreidels been stolen, but so have all of the servers that could replicate spinning a top!

Have no fear, though: you have the capability to spin not only dreidels, but to spin up serverless applications that can spin a dreidel just as well as you can!

Your task for today: create a REST API endpoint that spins a dreidel and randomly returns נ (Nun), ג (Gimmel), ה (Hay), or ש (Shin). This sounds like a great opportunity to use a serverless function to create an endpoint that any application can call!

Design Concepts: Silm
Design: Jaykay

## More information

 This API is running on an Azure Function App with PowerShell. Want to find out more about creating your own? Click [here]('https://4bes.nl/MSIgnite')

Barbara Forbes  
@Ba4bes  
[4bes.nl](https://4bes.nl)  

![PowerShell Function App](https://4bes.nl/wp-content/uploads/2019/11/PSFunctionApp-300x252.png)
