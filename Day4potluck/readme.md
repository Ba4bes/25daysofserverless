# 25daysofserverless Day 4

## Call the function

Now this was a real challenge. I have searched and searched and found absolutely no documentation about connecting a PowerShell Function app to a Cosmos DB (or any db for that matter).
So I had to find out on my own. The code around it is a bit sloppy, but I guess I have a new blog post to write now. :)

**Update**: I have cleaned up the code. [Click here for the original submission](https://github.com/Ba4bes/25daysofserverless/tree/430c7036b224d9dc75b3ce66accd65aa2a54f44d/Day4potluck)

The function AddMeal is able to add an entry or change an entry using the POST or PATCH Method, it accepts a JSON object

```PowerShell
$Body = @{
    Cook = "Harry"
    Meal = "Bread"
}
Invoke-RestMethod -Method POST -Uri "https://4besday4.azurewebsites.net/api/AddMeal" -Body ($body | ConvertTo-Json) -ContentType application/json
Thank you Harry!, your meal Bread has been added

$Body = @{
    Cook = "Harry"
    Meal = "Candy"
}
Invoke-RestMethod -Method PATCH -Uri "https://4besday4.azurewebsites.net/api/AddMeal" -Body ($body | ConvertTo-Json) -ContentType application/json
Thank you Harry!, your meal Candy has been added
```

The current Database entries can be grabbed through the function GetMeal

```PowerShell
 Invoke-RestMethod -Method GET -Uri "https://4besday4.azurewebsites.net/api/GetMeal"

Message                   Success data
-------                   ------- ----
5 objects have been found $true   {@{Cook=henk; Meal=bloib}, @{Cook=hank; Meal=bloib}, @{Cook=Fred; Meal=Cookie}, @{Cook=Beppie; Meal=Cow}…}
```

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
