// Copyright (c) 2015 Benoit Layer
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import EZClockView

let view = UIView(frame: CGRect(origin: CGPointZero, size: CGSizeMake(300.0, 200.0)))

let clock = EZClockView(frame: view.bounds)

// Setup time
clock.hours = 7
clock.minutes = 12
clock.seconds = 47

// You can also setup time like this
clock.setTime(NSDate(), animated: true)
clock.setTime(NSDate())

// Customize face with border thickness and background color
clock.faceBorderWidth = 3
clock.faceBackgroundColor = UIColor(white: 0.9, alpha: 1)

// Set the thickness of any needle
clock.hoursThickness = 3

// Set the length of any needle (1 means the needle is as long as the face radius)
clock.minutesLength = 0.5

// Offset is how far beyond the center the needle can go back.
clock.secondsOffset = 8

// You can customize several markings properties
clock.markingBorderSpacing = 5
clock.markingHourLength = 10
clock.markingMinuteLength = 5
clock.markingHourThickness = 3

clock.markingMinuteColor = UIColor.darkGrayColor()


view.addSubview(clock)
