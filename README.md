# AllTrailsAssessment

## Run Steps
```
cd AllTrailsAssessment-master/AllTrails`
pod install
open AllTrails.xcworkspace/
```

## Overview
This is the implementation of the All Trails at Lunch homework assessment. 

I've implemented this project in the same way I would implement a production iOS application. You'll notice the inclusion of development tools like SwiftGen, SwiftLint, etc to ensure code quality and increased safety in interacting with assets, colors, fonts, images, etc. 

### Behind the Scenes
- Tested across all iOS devices to ensure the application looks correct across different screen sizes
- Ensured no breaking constraints
- Added logging support
- All user facing text is localized
- MVVM + Coordinators
- Dependency Injection (where applicable)
- iOS 13.0+
- No warnings

## User Features
- All of the required features in the the "AllTrails Lunchtime Restaurant Discovery" document are implemented here
- Tapping on the restaurant in the list view and long pressing the info window on the map view will open the directions to the restaurant in Apple Maps
- Landscape support
- List view has full accessibility support
- Adding support to filter by "Open Now" status and $, $$, $$$, or $$$$
- Tracks user location
- Tells user they need to use enable location, will automatically fetch results once permissions change
- User facing error messaging

## What I'd Change
- I usually like to keep the names of the colors and the image names the same as what the design team calls them internally. I've found that this shared language helps when making UI changes. However, it seemed like the symbol names and screen names in Sketch were sort of informal, so I opted out of doing this here.
- I typically create a Theme class that encapsulated all of the varied styling in the application, but it just seemed a little overkill to do so for a small project like this.
- Typically wouldn't upload the API key to the repo, but including it here to ensure the project runs without any issue. It's never secure having the secret stored on the client, but seeing as this is a take home assessment, it seems permissible here. Additionally, the API key is loaded from a .plist which allows us to easily use different API keys against different targets / environments (if needed).
- Noticed the AllTrails app has Dark Mode support, but I didn't have time to implement it, so I've disabled it for now.
