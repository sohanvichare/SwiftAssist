## SwiftAssist
Crowdsourcing emergency response to bring you the help that you need, faster.


## Inspiration
Average 911 emergency response time in the United States is 10 minutes and 17 seconds.

**Serious allergies or asthma attacks can cause permanent damage or death in 5.**

We decided to build this app because we know multiple people who have serious allergies and we know that such an application would make them feel infinitely safer and could potentially save their lives.

## What it does
SwiftAssist crowdsources emergency response so that people who carry allergy medication, EpiPens, are CPR certified, or are a doctor can immediately respond to emergencies close to them, **faster than 911.**
People in dire need of help can send for help through a Pebble or iOS app with an easily accessible button. This request will then be processed, and every person in the area who is certified to help and can reach the location faster than 911 will be notified instantly.

The Web app is a control center where anybody can view all the emergencies that have been reported and view all activity that is going on, which would be useful to somebody at an emergency response system. In addition to this, it uses the Linkedin API to find concentrations of doctors in each area.

## How we built it
We used Firebase to store user data and for instant notifications. We use Pebble.js for the Pebble app. We use iOS and MapKit for the iOS application. We used Azure and the Photon board for a project to monitor weather data and relate it to emergency frequency.

## Challenges we ran into
1. iOS Push Notifications. We ran into a lot of problems implementing Azure Notifications Hub for iOS.
2. Getting Photon to work with Azure.

## Accomplishments that we're proud of
1. Getting Photon to work with Azure. None of us had very much C++ experience, but we were very proud when we finally interfaced and transferred weather data that could be analyzed by Azure.
2. Getting the app to work fully. We're very proud of this accomplishment and really believe that our app will save lives.

##Things that we learned
We did not have any previous experience with Pebble, and were able to build a fully functional and styled app use Pebble.js. Every member of our team can now confidently say that they know their way around Pebble. In addition to this, using Microsoft Technologies took quite a learning curve, but now much of our team has a greater understanding of how Azure functions.

## What's next for SwiftAssist
Android app, working more with Photon, emergency response directions from Pebble.
