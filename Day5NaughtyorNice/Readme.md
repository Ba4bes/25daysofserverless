# 25daysofserverless Day 5

## Process

Some new challenges for me. The first time I have used cogitive services :)
They are called by a Function App that also used Key Vault for the API secrets.
The output is an HTML page.

At this point I have combined the messages of the children and taken an average score. 
It does seam they are all naughty at this point, so I might change it up a bit later.

## Call the function 

The function is meant to be visited in a browser: <https://4besday5.azurewebsites.net/api/GetStats>

## The Challenge

### Naughty or Nice

*Thursday 5 December 2019* 
It's freezing cold up here on the North Pole, which normally makes it the ideal place to host a server farm. But today Santa's elves are freaking out!

Children all over the world write Santa letters to say what they want for Christmas. The elves had scripts running locally on the server farm to process the letters but without the missing servers this is no longer possible. Santa could translate manually, but he won't be able to get through all the letters in time!

Write a serverless application that helps Santa figure out if a given child is being naughty or nice based on what they've said. You'll likely need to detect the language of the correspondence, translate it, and then perform sentiment analysis to determine whether it's naughty or nice.

Have a look at the API https://aka.ms/holiday-wishes to find a sample of messages to validate whether your solution will work for Santa and his elves. 
Here in Brooklyn, NY, Ezra wants to have a big holiday potluck before everyone travels home for the holidays! His tiny apartment can barely fit everyone in, but it's a cozy way to celebrate with friends. He usually uses an online spreadsheet to coordinate who's bringing what, to make sure there's varieties of food to meet all dietary needs.

But the grinch stole all the servers! So Ezra can't do that this year.

Build an HTTP API that lets Ezra's friends add food dishes they want to bring to the potluck, change or remove them if they need to (plans change!), and see a list of what everybody's committed to bring.

## More information

# Useful links



https://blog.kloud.com.au/2018/08/28/using-azure-cognitive-services-language-text-translation-with-powershell/

https://stackoverflow.com/questions/15290185/invoke-webrequest-issue-with-special-characters-in-json


 This api is running on an Azure Function App with PowerShell. Want to find out more about creating your own? Click [here]('https://4bes.nl/MSIgnite')

Barbara Forbes  
@Ba4bes  
[4bes.nl](https://4bes.nl)  

![PowerShell Function App](https://4bes.nl/wp-content/uploads/2019/11/PSFunctionApp-300x252.png)
