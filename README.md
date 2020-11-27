# AllTrailsAssessment

## Overview
As requested, I implemented this project in the same way I would approach any production iOS application. You'll notice the inclusion of SwiftGen and SwiftLint in this project to ensure code quality and increased safety in interacting with assets (colors, fonts, images, etc). 

### Behind the Scenes
- Tested across all iOS devices to ensure the application looks correct across different screen sizes. 
- Ensured no breaking constraints
- Added user facing error messaging
- Added logging support
- All user facing text is localized
- MVVM
- Dependency injection where applicable
- iOS 13.0+
- No warnings

## User Features
- All of the required features in the the "AllTrails Lunchtime Restaurant Discovery" are implemented here. 
- Tapping on the restaurant in the list view and long pressing the info windows on the map view will open the directions to the restaurant in Apple Maps.
- Full landscape support
- Adding support to filter by "Open Now" status and $, $$, $$$, or $$$$

## What I'd Change
- I usually like to keep the names of the colors and the image names the same as what the design team calls them internally. I've found that this shared language helps when making UI changes. However, it seemed like the symbol names and screen names in Sketch were sort of informal, so I opted out of doing this here.
- Additionally, I typically create a Theme class that encapsulated all of the varied styling in the application, but it just seemed a little overkill to do so for a small project like this and even more difficult to do without fully understanding all of the brand guidelines. 
