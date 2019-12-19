# 25daysofserverless Day 19

## Azure Function App

I was a bit confused about the assignment, because I'm not sure how the compressor works.
So I assumed the tank goes completely empty. At that point the Compressor sends out a start signal and starts filling.
With this app you can check how far allong it is for that time.

To simulate the Compressor I used the function SimulateCompressor, that sends messages to the IOT hub.
The function GetStartStopStatus is triggered by the Event hub and puts that message into a storage blob.

Finally GetAirInTank reads that message in the storage blob and calculated how many air and balloons are in the tank.

## The Challenge

### Balloons

*Thursday, 19 December*  
Let's head over to the South of France where Julie and her colleagues have decided to prepare a special gift for all patients where she is working: custom-shaped inflatable balloons for the holidays! In order to make them, she'll need to inflate a LOT of balloons with the help of an air compressor and one 12 litres air tank.

Julie has some IoT devices that tell her when the air compressor is starting and stopping to fill the tanks. Can we write her a service that will compute the amount of air available and let her know if she has enough air for her balloons?

Let's assume that our compressor is filling a 12 litres air tank, at the rate of 25 bar (around 360psi) per minute. The max pressure of the tank is 200 bar. You'll need to deduce the actual pressure of the tank and the number of balloons Julie can inflate at any point in time, knowing each balloon consumes 0,6 bar of the air tank pressure.

A great way to model this would be to use the Azure IoT Hub. You can create some Azure Functions Durable Entities to model a "tank" or "compressor" entity, as well as another Azure Function

If you like physics: we have assumed the compressor is working at a rate of 18 m3/hour, and that a balloon is 4 litres inflated at 2 bar. With Boyle-Mariotte law (or Van der Walls equations), you should be able to do more precise calculations.

## More information

 This app is running on an Azure Function App with PowerShell. Want to find out more about creating your own? Click [here]('https://4bes.nl/MSIgnite')

Barbara Forbes  
[@Ba4bes](https://www.twitter.com/ba4bes)  
[4bes.nl](https://4bes.nl)
