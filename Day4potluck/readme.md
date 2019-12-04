# 25daysofserverless Day 4

## Call the function

Now this was a real challenge. I have searched and searched and found absolutely no documentation about connecting a PowerShell Function app to a Cosmos DB (or any db for that matter).
So I had to find out on my own. The code around it is a bit sloppy, but I guess I have a new blog post to write now. :)

The function AddMeal is able to add an entry or change an entry like this:

```PowerShell
Invoke-RestMethod -Uri "https://4besday4.azurewebsites.net/api/AddMeal?Cook=Harry&Meal=Candy"
Thank you Harry!, your meal Candy has been added

Invoke-RestMethod -Uri "https://4besday4.azurewebsites.net/api/AddMeal?Cook=Harry&Meal=Cake"
Thank you Harry!, your meal Cake has been added
```

The db-info can be grabbed through the function GetMeal

```PowerShell
 Invoke-RestMethod -Uri "https://4besday4.azurewebsites.net/api/GetMeal"

Cook  Meal
----  ----
Henk  Sausage
Mary  Soup
Harry Cake
```

Like I said, not the cleanest as I was running out of time. To be continued :-)

## The Challenge

### The potluck

*Wednesday 4 December 2019*  
Here in Brooklyn, NY, Ezra wants to have a big holiday potluck before everyone travels home for the holidays! His tiny apartment can barely fit everyone in, but it's a cozy way to celebrate with friends. He usually uses an online spreadsheet to coordinate who's bringing what, to make sure there's varieties of food to meet all dietary needs.

But the grinch stole all the servers! So Ezra can't do that this year.

Build an HTTP API that lets Ezra's friends add food dishes they want to bring to the potluck, change or remove them if they need to (plans change!), and see a list of what everybody's committed to bring.

## More information

 This api is running on an Azure Function App with PowerShell. Want to find out more about creating your own? Click [here]('https://4bes.nl/MSIgnite')

Barbara Forbes  
@Ba4bes  
[4bes.nl](https://4bes.nl)  

![PowerShell Function App](https://4bes.nl/wp-content/uploads/2019/11/PSFunctionApp-300x252.png)
