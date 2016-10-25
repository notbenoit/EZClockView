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

@IBDesignable
open class EZClockView: UIView {
	
	// MARK: - Properties
	fileprivate var faceView: UIView = UIView()
	fileprivate var centerView: UIView = UIView()
	fileprivate var handHours: UIView = UIView()
	fileprivate var handMinutes: UIView = UIView()
	fileprivate var handSeconds: UIView = UIView()
	fileprivate var markingsView: MarkingsView = MarkingsView(frame: CGRect.zero)
	
	fileprivate var hourProperty: Int = 0
	fileprivate var minuteProperty: Int = 0
	fileprivate var secondProperty: Int = 0
	
	// MARK: animation
	/// Set the animation duration (the view is animated when calling the setTime methods)
	open var animationDuration: TimeInterval = 0.3
	
	// MARK: Time
	/// Set this property to change the hour hand position.
	@IBInspectable open var hours: Int {
		get {
			return hourProperty
		}
		set {
			hourProperty = newValue
			updateHands()
		}
	}
	/// Set this property to change the minutes hand position.
	@IBInspectable open var minutes: Int {
		get {
			return minuteProperty
		}
		set {
			minuteProperty = newValue
			updateHands()
		}
	}
	/// Set this property to change the seconds hand position.
	@IBInspectable open var seconds: Int {
		get {
			return secondProperty
		}
		set {
			secondProperty = newValue
			updateHands()
		}
	}
	
	// MARK: Face
	/// Defines the background color of the face. Defaults to white.
	@IBInspectable open var faceBackgroundColor: UIColor = UIColor.white { didSet { faceView.backgroundColor = faceBackgroundColor } }
	/// Defines the border color of the face. Defaults to black.
	@IBInspectable open var faceBorderColor: UIColor = UIColor.black
	/// Defines the border width of the face. Defaults to 2.
	@IBInspectable open var faceBorderWidth: CGFloat = 2.0
	
	// MARK: Center disc
	/// Defines the color of the rounded part in the middle of the face, over the needles. Default is red.
	@IBInspectable open var centerColor: UIColor = UIColor.red { didSet { centerView.backgroundColor = centerColor } }
	/// Desfines the width of the center circle. Default is 3.0.
	@IBInspectable open var centerRadius: CGFloat = 3.0 { didSet { setupCenterView() } }
	/// Defines the width for the border of this center part. Default is 1.0.
	@IBInspectable open var centerBorderWidth: CGFloat = 1.0 { didSet { centerView.layer.borderWidth = centerBorderWidth } }
	/// Defines the color for the border of this center part. Default is red.
	@IBInspectable open var centerBorderColor: UIColor = UIColor.red { didSet { centerView.layer.borderColor = centerBorderColor.cgColor } }
	
	// MARK: Hour hand
	/// Defines the color for the hours hand. Default to black.
	@IBInspectable open var hoursColor: UIColor = UIColor.black { didSet { handHours.backgroundColor = hoursColor } }
	/// Defines the length of the hours hand. It is represented as a ratio of the radius of the face. Default to 0.5.
	@IBInspectable open var hoursLength: CGFloat = 0.5 {
		didSet { setupHand(handHours, lengthRatio: hoursLength, thickness: hoursThickness, offset: hoursOffset) }
	}
	/// Defines the thickness of the hours hand. Default is 4.
	@IBInspectable open var hoursThickness: CGFloat = 4 {
		didSet { setupHand(handHours, lengthRatio: hoursLength, thickness: hoursThickness, offset: hoursOffset) }
	}
	/// Defines the distance by which the hours hand will overlap over the center of the face. Default is 2.
	@IBInspectable open var hoursOffset: CGFloat = 2 {
		didSet { setupHand(handHours, lengthRatio: hoursLength, thickness: hoursThickness, offset: hoursOffset) }
	}
	
	// MARK: Minute hand
	/// Defines the color for the minutes hand. Default to black.
	@IBInspectable open var minutesColor: UIColor = UIColor.black { didSet { handMinutes.backgroundColor = minutesColor } }
	/// Defines the length of the minutes hand. It is represented as a ratio of the radius of the face. Default to 0.7.
	@IBInspectable open var minutesLength: CGFloat = 0.7 {
		didSet { setupHand(handMinutes, lengthRatio: minutesLength, thickness: minutesThickness, offset: minutesOffset) }
	}
	/// Defines the thickness of the minutes hand. Default is 2.
	@IBInspectable open var minutesThickness: CGFloat = 2 {
		didSet { setupHand(handMinutes, lengthRatio: minutesLength, thickness: minutesThickness, offset: minutesOffset) }
	}
	/// Defines the distance by which the minutes hand will overlap over the center of the face. Default is 2.
	@IBInspectable open var minutesOffset: CGFloat = 2 {
		didSet { setupHand(handMinutes, lengthRatio: minutesLength, thickness: minutesThickness, offset: minutesOffset) }
	}
	
	// MARK: Second hand
	/// Defines the color for the seconds hand. Default to red.
	@IBInspectable open var secondsColor: UIColor = UIColor.red { didSet { handSeconds.backgroundColor = secondsColor } }
	/// Defines the length of the seconds hand. It is represented as a ratio of the radius of the face. Default to 0.8.
	@IBInspectable open var secondsLength: CGFloat = 0.8 {
		didSet { setupHand(handSeconds, lengthRatio: secondsLength, thickness: secondsThickness, offset: secondsOffset) }
	}
	/// Defines the thickness of the seconds hand. Default is 1.
	@IBInspectable open var secondsThickness: CGFloat = 1 {
		didSet { setupHand(handSeconds, lengthRatio: secondsLength, thickness: secondsThickness, offset: secondsOffset) }
	}
	/// Defines the distance by which the seconds hand will overlap over the center of the face. Default is 2.
	@IBInspectable open var secondsOffset: CGFloat = 2 {
		didSet { setupHand(handSeconds, lengthRatio: secondsLength, thickness: secondsThickness, offset: secondsOffset) }
	}
	
	// MARK: Markings
	// Margin from the border of the clock.
	@IBInspectable open var markingBorderSpacing: CGFloat = 20 { didSet { markingsView.borderSpacing = markingBorderSpacing } }
	
	// Length in points of the hour markings.
	@IBInspectable open var markingHourLength: CGFloat = 20 { didSet { markingsView.hourMarkingLength = markingHourLength } }
	@IBInspectable open var markingHourThickness: CGFloat = 1 { didSet { markingsView.hourMarkingThickness = markingHourThickness } }
	@IBInspectable open var markingHourColor: UIColor = UIColor.black { didSet { markingsView.hourMarkingColor = markingHourColor } }
	
	// Length in points of the minute markings.
	@IBInspectable open var markingMinuteLength: CGFloat = 10 { didSet { markingsView.minuteMarkingLength = markingMinuteLength } }
	@IBInspectable open var markingMinuteThickness: CGFloat = 1 { didSet { markingsView.minuteMarkingThickness = markingMinuteThickness } }
	@IBInspectable open var markingMinuteColor: UIColor = UIColor.black { didSet { markingsView.minuteMarkingColor = markingMinuteColor } }
	
	@IBInspectable open var shouldDrawHourMarkings: Bool = true { didSet { markingsView.shouldDrawHourMarkings = shouldDrawHourMarkings } }
	@IBInspectable open var shouldDrawMinuteMarkings: Bool = true { didSet { markingsView.shouldDrawMinuteMarkings = shouldDrawMinuteMarkings } }
	
	// MARK: - Public methods
	/**
	Set the time the clock will display. You can animate it or not.
	
	- parameter h: The hour to set
	- parameter m: The minute to set
	- parameter s: The second to set
	- parameter animated: Whether or not the change should be animated (default to false).
	*/
	open func setTime(h: Int, m: Int, s: Int, animated: Bool = false) {
		hourProperty = h
		minuteProperty = m
		secondProperty = s
		updateHands(animated)
	}
	
	/**
	Set the time the clock will display directly by using an NSDate instance.
	
	- parameter date: The date to display. Only hours, minutes, and seconds, will be taken into account.
	- parameter animated: Whether or not the change should be animated (default to false).
	*/
	open func setTime(_ date: Date, animated: Bool = false) {
		let components = (Calendar.current as NSCalendar).components(([NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second]), from: date)
		hourProperty = components.hour!
		minuteProperty = components.minute!
		secondProperty = components.second!
		updateHands(animated)
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		
		let clockRadius = min(self.bounds.size.width, self.bounds.size.height)
		
		// Reset all transforms
		setupHand(handHours, lengthRatio: hoursLength, thickness: hoursThickness, offset: hoursOffset)
		setupHand(handMinutes, lengthRatio: minutesLength, thickness: minutesThickness, offset: minutesOffset)
		setupHand(handSeconds, lengthRatio: secondsLength, thickness: secondsThickness, offset: secondsOffset)
		
		setupCenterView()
		
		handHours.backgroundColor = hoursColor
		handMinutes.backgroundColor = minutesColor
		handSeconds.backgroundColor = secondsColor
		
		faceView.frame.size = CGSize(width: clockRadius, height: clockRadius)
		faceView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
		faceView.layer.cornerRadius = clockRadius/2.0
		faceView.backgroundColor = faceBackgroundColor
		faceView.layer.borderWidth = faceBorderWidth
		faceView.layer.borderColor = faceBorderColor.cgColor
		
		markingsView.frame = faceView.frame
		
		setTime(h: hours, m: minutes, s: seconds)
	}
	
	open override func willMove(toSuperview newSuperview: UIView?) {
		if (faceView.superview == nil) {
			
			self.backgroundColor = UIColor.clear
			
			self.addSubview(faceView)
			self.addSubview(handHours)
			self.addSubview(handMinutes)
			self.addSubview(handSeconds)
			self.addSubview(centerView)
			
			self.addSubview(markingsView)
		}
	}
	
	// MARK: - Private methods
	fileprivate func setupHand(_ hand: UIView, lengthRatio: CGFloat, thickness: CGFloat, offset: CGFloat) {
		hand.transform = CGAffineTransform.identity
		hand.layer.allowsEdgeAntialiasing = true
		
		let clockRadius = min(self.bounds.size.width, self.bounds.size.height)
		let handLength = (clockRadius/2.0) * CGFloat(lengthRatio)
		
		let anchorX: CGFloat = 0.5
		let anchorY: CGFloat = 1.0 - (offset/handLength)
		hand.layer.anchorPoint = CGPoint(x: anchorX, y: anchorY)
		
		let centerInParent = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
		hand.frame = CGRect(x: centerInParent.x-(thickness/2), y: centerInParent.y - handLength + offset, width: thickness, height: handLength)
		
		// Replace the hand at appropriate position
		updateHands()
	}
	
	fileprivate func setupCenterView() {
		centerView.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: centerRadius*2, height: centerRadius*2))
		centerView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
		centerView.layer.cornerRadius = centerRadius
		centerView.backgroundColor = centerColor
		centerView.layer.borderColor = centerBorderColor.cgColor
		centerView.layer.borderWidth = centerBorderWidth
	}
	
	fileprivate func updateHands(_ animated: Bool = false) {
		// Put everything in seconds to have ratios
		let hoursInSeconds = (hours%12)*3600
		let minutesInSeconds = (minutes%60)*60
		let secondsInSeconds = (seconds%60)
		
		let hoursRatio = CGFloat(hoursInSeconds + minutesInSeconds + secondsInSeconds) / 43200.0
		let minutesRatio = CGFloat(minutesInSeconds + secondsInSeconds) / 3600.0
		let secondsRatio = CGFloat(secondsInSeconds) / 60.0
		
		if (animated) {
			UIView.animate(withDuration: animationDuration, animations: {
				self.handSeconds.transform = CGAffineTransform(rotationAngle: CGFloat(2*M_PI)*secondsRatio)
				self.handMinutes.transform = CGAffineTransform(rotationAngle: CGFloat(2*M_PI)*minutesRatio)
				self.handHours.transform = CGAffineTransform(rotationAngle: CGFloat(2*M_PI)*hoursRatio)
			})
		} else {
			handSeconds.transform = CGAffineTransform(rotationAngle: CGFloat(2*M_PI)*secondsRatio)
			handMinutes.transform = CGAffineTransform(rotationAngle: CGFloat(2*M_PI)*minutesRatio)
			handHours.transform = CGAffineTransform(rotationAngle: CGFloat(2*M_PI)*hoursRatio)
		}
	}
}
