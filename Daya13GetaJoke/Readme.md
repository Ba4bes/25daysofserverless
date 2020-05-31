# 25daysofserverless Day 13B

## Azure Function App

**Update**: I have cleaned up this code. [Click here for the original submission](https://github.com/Ba4bes/25daysofserverless/tree/7ce8a7da8a4cb42371d7b87e2b6861a181bb7d6a/Daya13GetaJoke)

I was in no way able to complete the original challenge.
I have no experience with python. Or Machine learning. And at that point, it is in my opinion not possible to complete this challenge in a day. I feel it is a bit to specific.

So I made my own challenge, based on the real challenge. 
I have created a blob triggered function app that responds to the dataset that is uploaded.
It takes all the entries in the dataset and uses the Sentiment analysis service to give every joke a score. This is the base to work on and the jokes with their scores are stored in a CosmosDB.

When the tricksters want to get a joke, they can call on <https://4besday13.azurewebsites.net/api/GetJoke>.
This website will give one of the jokes that is in the top 25 of the highest scores in the database. 
The trickster can then rate if the joke is funny or not. If they enter that the joke isn't funny, the score is reduced by 0.10 points. If it is funny, it is increased by .10 points. The new data is written to the database.

So if enough tricksters use the joke-site, you should always get one of the 25 funniest jokes in the database.

Everything is of course running on PowerShell function apps, with CosmosDB. 

## Call the function

Call the function here: <https://4besday13.azurewebsites.net/api/GetJoke>

## The Challenge

### THE YULE LADS

*Friday, 13 December*
Here in Iceland, the holidays are full of tricksy traditions. For the thirteen days leading up to Christmas, it's said that children are visited each night by one of the thirteen Yule Lads (Jólasveinar), a motley crew of trolls with their own distinct personalities. Kertasníkir, the Candle-Stealer, follows children and steals their candles, whereas Þvörusleikir, the Spoon-Licker, loves to steal wooden spoons and lick the food off of them. And the big scary Christmas cat Jólakötturinn will devour any children who haven't gotten a new piece of clothing as a Christmas gift!

Each night, children put out their shoes by the window. When that night's visiting Yule Lad shows up, they leave gifts in the shoes of nice girls and boys, and rotting potatoes for the naughty ones.

This year, the thirteen tricksters are ready to get a bit more tech-savvy! They'd like to use machine learning to generate jokes they can say to children. They have a big book of jokes to train a machine learning model to generate a new joke for them every time they need one. Use this sample dataset extracted from icanhazdadjoke api as a blob trigger to create a troll joke generator for our tricksters.

## More information

 This app is running on an Azure Function App with PowerShell. Want to find out more about creating your own? Click [here]('https://4bes.nl/MSIgnite')

Barbara Forbes  
[@Ba4bes](https://www.twitter.com/ba4bes)  
[4bes.nl](https://4bes.nl)
