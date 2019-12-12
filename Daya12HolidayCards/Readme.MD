https://developer.github.com/v3/markdown/

https://gist.github.com/lidopaglia/3739453#file-convertfrom-markdown-ps1-L36

# 25daysofserverless Day 12

## Azure Function App

I thought I would be done quickly with this Function App, as PowerShell has a ConvertFrom-Markdown cmdlet. Only I could not get it to work within the function. Locally there was no problem. But when running the debug mode or deploying to Azure... No luck. I suspect this to be a bug in the cmdlet.

After a lot of trying and failing, I found out about the [Github Api for markdown](https://developer.github.com/v3/markdown/), and a sample script in [a gist](https://gist.github.com/lidopaglia/3739453#file-convertfrom-markdown-ps1-L36).
That worked as well!

I spend some time with everything surrounding the function app. So you can call it as a restcall or in a browser, by adding the GistID. It can show you a HTML page, or the raw html file. You switch between those by adding "Raw=true" to the URL. If multiple files are in the gist, it combines multiple files in one output.

## Call the function

For example, you can use this url in your browser: 

<https://4besday12.azurewebsites.net/api/GistToWeb?GistID=0cc1640aabf9825ebd4fd727e8c72591>  
(click it, is will give you a picture of my dog!)

This is based on the following Gist: <https://gist.github.com/Ba4bes/0cc1640aabf9825ebd4fd727e8c72591>.

To view the HTML, Add "Raw=true" to the URL: <https://4besday12.azurewebsites.net/api/GistToWeb?GistID=0cc1640aabf9825ebd4fd727e8c72591&Raw=true>

## The Challenge

### Holiday cards

*Thursday, 12 December*
Today in London, Simona wants to send beautiful holiday cards to all her friends But since she's worried they won't arrive in time, she doesn't want to hand-write and mail each individual letter!

Instead, she wants to make each of her friends a personalized website containing a holiday letter for them! She plans on writing each letter as its own Markdown file, and needs a way to turn those into websites.

Create a service that reads Markdown text from GitHub (perhaps using the Gist API), parses the Markdown to HTML, and returns the HTML to the client.

As a bonus challenge: reading and parsing Markdown is a lot of work! To optimize, cache your responses and send cached versions of the processed Markdown.

## More information

 This app is running on an Azure Function App with PowerShell. Want to find out more about creating your own? Click [here]('https://4bes.nl/MSIgnite')

Barbara Forbes  
[@Ba4bes](https://www.twitter.com/ba4bes)  
[4bes.nl](https://4bes.nl)
