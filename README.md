# Reciplease

<p align="left">
    <a href="https://swift.org/">
        <img src="https://img.shields.io/badge/Swift-5+-F05138?color=blue&labelColor=303840" alt="Swift: 5+">
    </a>
    &nbsp; &nbsp;
    <a href="https://www.apple.com/ios/">
        <img src="https://img.shields.io/badge/iOS-15+-007AFF?labelColor=303840" alt="iOS: 15+">
    </a> 
</p>

Reciplease is an iOS application that allows you to search for recipes and save some of them as favorites.

## Context
I created this iOS app as part of my Openclassrooms iOS App Developer Training.
It's made with **UIkit** and **Firestore**.
It uses [Edamam API](https://www.edamam.com/) as its recipes database.
Particular attention has been paid to accessibility with VoiceOver.

## Installation
There are some prerequisites to use Reciplease. 

For Firestore:
- create a Firebase project and activate Firestore,
- download GoogleService-Info.plist file from Firebase project and put it in the folder 'Reciplease/Supporting files' of the application project.

For Edamam API:
- create an account on Edamam website and a new application with an access to the Recipe Search API,
- rename Alamofire-Info.template.plist to Alamofire-Info.plist and put in it application id and application key you got. 
    
Then build the project in **Xcode**.
