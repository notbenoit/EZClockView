![EZClockView](https://raw.githubusercontent.com/notbenoit/notbenoit.github.io/master/images/ezclockview/ezclockview.png)

[![Build Status](https://travis-ci.org/notbenoit/EZClockView.svg?branch=master)](https://travis-ci.org/notbenoit/EZClockView)

# EZClockView
EZClockView is an iOS framework (MacOS soon) which provides a ClockView to display time. It could be used directly in nib files or in code.


## Requirements

- iOS 7.0+
- Xcode 6.1

## Installation

### CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

CocoaPods 0.36 beta adds supports for Swift and embedded frameworks. You can install it with the following command:

```bash
$ gem install cocoapods --pre
```

To add `EZClockView` to your project, add this line to your  `Podfile` (WIP on develop branch) :

```ruby
pod 'EZClockView', :git => 'https://github.com/notbenoit/EZClockView.git', :branch => 'develop'
```

### Manual
- Simply add the `EZClockView.xcodeproj` to your workspace and add its framework output as a dependency of your project.
- You can also build the framework and directly link it to your target.

## Usage
To use the EZClockView, instantiate it as you would instantiate a UIView. Then modify it as you like (colors, thickness, hand length...)

### By code

Create a new instance of the EZClockView class, and add it as a subview of any view. A sample worth a thousand words :

```swift
let clock = EZClockView(frame: view.bounds)

// Setup time
clock.hours = 7
clock.minutes = 12
clock.seconds = 47

// Customize face with border thickness and background color
clock.faceBorderWidth = 3
clock.faceBackgroundColor = UIColor(white: 0.9, alpha: 1)

// Set the thickness of any needle
clock.hoursThickness = 5

// Set the length of any needle (1 means the needle is as long as the face radius)
clock.minutesLength = 0.5

// Offset is how far beyond the center the needle can go back.
clock.secondsOffset = 5

view.addSubview(clock)

```

Take a look at the playground shipped with the workspace.

### In a xib file
Drag a UIView in your xib file and set its class to EZClock and its module to EZClockView.
Then, edit any property as you like

![IB](https://raw.githubusercontent.com/notbenoit/notbenoit.github.io/master/images/ezclockview/IB_design.png)

## Creator

- [Benoît Layer](http://github.com/notbenoit) ([@notbenoit](https://twitter.com/notbenoit))

## License

EZClockView is released under the MIT license. See LICENSE for details.
