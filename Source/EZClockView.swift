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
public class EZClockView: UIView {
    
    // MARK: - Properties
    private var faceView: UIView = UIView()
    private var handHours: UIView = UIView()
    private var handMinutes: UIView = UIView()
    private var handSeconds: UIView = UIView()
    
    private var sideLength: CGFloat = 0
    
    // MARK: Time
    @IBInspectable public var hours: Int = 0 { didSet { updateHands() } }
    @IBInspectable public var minutes: Int = 0 { didSet { updateHands() } }
    @IBInspectable public var seconds: Int = 0 { didSet { updateHands() } }
    
    // MARK: Face
    @IBInspectable public var faceBackgroundColor: UIColor = UIColor.whiteColor() { didSet { faceView.backgroundColor = faceBackgroundColor } }
    @IBInspectable public var faceBorderColor: UIColor = UIColor.blackColor()
    @IBInspectable public var faceBorderWidth: CGFloat = 2.0
    
    // MARK: Hour hand
    @IBInspectable public var hoursColor: UIColor = UIColor.blackColor() { didSet { handHours.backgroundColor = hoursColor } }
    @IBInspectable public var hoursLength: CGFloat = 0.5 {
        didSet { setupHand(handHours, lengthRatio: hoursLength, thickness: hoursThickness, offset: hoursOffset) }
    }
    @IBInspectable public var hoursThickness: CGFloat = 4 {
        didSet { setupHand(handHours, lengthRatio: hoursLength, thickness: hoursThickness, offset: hoursOffset) }
    }
    @IBInspectable public var hoursOffset: CGFloat = 2 {
        didSet { setupHand(handHours, lengthRatio: hoursLength, thickness: hoursThickness, offset: hoursOffset) }
    }
    
    // MARK: Minute hand
    @IBInspectable public var minutesColor: UIColor = UIColor.blackColor() { didSet { handMinutes.backgroundColor = minutesColor } }
    @IBInspectable public var minutesLength: CGFloat = 0.7 {
        didSet { setupHand(handMinutes, lengthRatio: minutesLength, thickness: minutesThickness, offset: minutesOffset) }
    }
    @IBInspectable public var minutesThickness: CGFloat = 2 {
        didSet { setupHand(handMinutes, lengthRatio: minutesLength, thickness: minutesThickness, offset: minutesOffset) }
    }
    @IBInspectable public var minutesOffset: CGFloat = 2 {
        didSet { setupHand(handMinutes, lengthRatio: minutesLength, thickness: minutesThickness, offset: minutesOffset) }
    }
    
    // MARK: Second hand
    @IBInspectable public var secondsColor: UIColor = UIColor.redColor() { didSet { handSeconds.backgroundColor = secondsColor } }
    @IBInspectable public var secondsLength: CGFloat = 0.8 {
        didSet { setupHand(handSeconds, lengthRatio: secondsLength, thickness: secondsThickness, offset: secondsOffset) }
    }
    @IBInspectable public var secondsThickness: CGFloat = 1 {
        didSet { setupHand(handSeconds, lengthRatio: secondsLength, thickness: secondsThickness, offset: secondsOffset) }
    }
    @IBInspectable public var secondsOffset: CGFloat = 2 {
        didSet { setupHand(handSeconds, lengthRatio: secondsLength, thickness: secondsThickness, offset: secondsOffset) }
    }
    
    // MARK: - Public methods
    public func setTime(#h: Int, m: Int, s: Int, animated: Bool = false) {
        hours = h
        minutes = m
        seconds = s
        updateHands(animated: animated)
    }
    
    public func setTime(date: NSDate, animated: Bool = false) {
        let components = NSCalendar.currentCalendar().components((.HourCalendarUnit | .MinuteCalendarUnit | .SecondCalendarUnit), fromDate: date)
        hours = components.hour
        minutes = components.minute
        seconds = components.second
        updateHands(animated: animated)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // Place subviews according to values for hour minutes seconds
        sideLength = min(self.bounds.size.width, self.bounds.size.height)
        
        // Reset all transforms
        setupHand(handHours, lengthRatio: hoursLength, thickness: hoursThickness, offset: hoursOffset)
        setupHand(handMinutes, lengthRatio: minutesLength, thickness: minutesThickness, offset: minutesOffset)
        setupHand(handSeconds, lengthRatio: secondsLength, thickness: secondsThickness, offset: secondsOffset)
        
        handHours.backgroundColor = hoursColor
        handMinutes.backgroundColor = minutesColor
        handSeconds.backgroundColor = secondsColor
        
        faceView.frame.size = CGSize(width: sideLength, height: sideLength)
        faceView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        faceView.layer.cornerRadius = sideLength/2.0
        faceView.backgroundColor = faceBackgroundColor
        faceView.layer.borderWidth = faceBorderWidth
        faceView.layer.borderColor = faceBorderColor.CGColor
        
        setTime(h: hours, m: minutes, s: seconds)
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        if (faceView.superview == nil) {
            
            self.backgroundColor = UIColor.clearColor()
            
            self.addSubview(faceView)
            self.addSubview(handHours)
            self.addSubview(handMinutes)
            self.addSubview(handSeconds)
        }
    }
    
    // MARK: - Private methods
    private func setupHand(hand: UIView, lengthRatio: CGFloat, thickness: CGFloat, offset: CGFloat) {
        hand.transform = CGAffineTransformIdentity
        let handLength = (sideLength/2) * lengthRatio
        
        let anchorX: CGFloat = 0.5
        let anchorY: CGFloat = 1.0 - (offset/handLength)
        hand.layer.anchorPoint = CGPoint(x: anchorX, y: anchorY)
        
        let centerInParent = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        hand.frame = CGRectMake(centerInParent.x-(thickness/2), centerInParent.y - handLength + offset, thickness, handLength)
    }
    
    private func updateHands(animated: Bool = false) {
        // Put everything in seconds to have ratios
        let hoursInSeconds = (hours%12)*3600
        let minutesInSeconds = (minutes%60)*60
        let secondsInSeconds = (seconds%60)
        
        let hoursRatio = CGFloat(hoursInSeconds + minutesInSeconds + secondsInSeconds) / 43200.0
        let minutesRatio = CGFloat(minutesInSeconds + secondsInSeconds) / 3600.0
        let secondsRatio = CGFloat(secondsInSeconds) / 60.0
        
        if (animated) {
            UIView.animateWithDuration(0.3) {
                self.handSeconds.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI)*secondsRatio)
                self.handMinutes.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI)*minutesRatio)
                self.handHours.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI)*hoursRatio)
            }
        } else {
            handSeconds.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI)*secondsRatio)
            handMinutes.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI)*minutesRatio)
            handHours.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI)*hoursRatio)
        }
    }
}
