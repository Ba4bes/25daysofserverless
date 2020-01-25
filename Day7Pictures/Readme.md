# 25daysofserverless Day 7

## Process

**Update**: I have cleaned up this code. [Click here for the original submission](https://github.com/Ba4bes/25daysofserverless/tree/65359ca9a7ed21d9b660e02ee37c27c9113ebd11/Day7Pictures)


Two functions in an App for this one. Of course I use PowerShell.
It is a bit weird to use HTML within PowerShell, but it works.

The first function, FrontPage, collects the input from the user.
It does so by creating a simple HTML web form. The results of the form are send to the second function

The second funtion connects to the UnSplash API and collects an image. 
It returns the image in an HTML page to the browser.
The UnsplashAPIkey is stored in the environment variables of the function

To make the URL cleaner I have removed the API-part through the host.json file

## Call the function

The function is meant to be visited in a browser: <https://4besday7.azurewebsites.net/FrontPage>

## The Challenge

### la quema del diablo

*Thursday 7 December 2019*  
December 7 marks the first day of the official Christmas season in Guatemala. Everybody is scrambling to get ready for the big la quema del diablo (burning of the devil) tonight — at 6pm sharp, everyone will start a bonfire to burn rubbish and items they don't need to cleanse their homes of evil.

Here in Guatemala City, our friend Miguel is concerned about the environmental impact! The past few years, people have been burning a lot of rubber and plastic that makes the air dirty. Some places are switching to burning paper piñatas of the devil, but Miguel still wants to let people metaphorically cleanse their houses of specific items they don't want.

Let's help Miguel by building a web API that lets his neighbors search for images of things they want to get rid of. Build an application (e.g. a cloud function with a single endpoint) that takes text as an input and returns an image found on unsplash or another image platform.

## More information

 This site is running on an Azure Function App with PowerShell. Want to find out more about creating your own? Click [here]('https://4bes.nl/MSIgnite')

Barbara Forbes  
@Ba4bes  
[4bes.nl](https://4bes.nl)  

![PowerShell Function App](https://4bes.nl/wp-content/uploads/2019/11/PSFunctionApp-300x252.png)
