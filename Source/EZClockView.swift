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
    
    private var handHours: UIView = UIView()
    private var faceView: UIView = UIView()
    private var handMinutes: UIView = UIView()
    private var handSeconds: UIView = UIView()
    
    @IBInspectable public var faceBackgroundColor: UIColor = UIColor.whiteColor()
    @IBInspectable public var faceBorderColor: UIColor = UIColor.blackColor()
    @IBInspectable public var faceBorderWidth: CGFloat = 2.0
    
    @IBInspectable public var hours: Int = 0 { didSet { setTime(h: hours, m: minutes, s: seconds) } }
    @IBInspectable public var minutes: Int = 0 { didSet { setTime(h: hours, m: minutes, s: seconds) } }
    @IBInspectable public var seconds: Int = 0 { didSet { setTime(h: hours, m: minutes, s: seconds) } }
    
    @IBInspectable public var hoursColor: UIColor = UIColor.blackColor()
    @IBInspectable public var hoursLength: CGFloat = 0.5
    @IBInspectable public var hoursThickness: CGFloat = 4
    @IBInspectable public var hoursOffset: CGFloat = 2
    
    @IBInspectable public var minutesColor: UIColor = UIColor.blackColor()
    @IBInspectable public var minutesLength: CGFloat = 0.7
    @IBInspectable public var minutesThickness: CGFloat = 2
    @IBInspectable public var minutesOffset: CGFloat = 2
    
    @IBInspectable public var secondsColor: UIColor = UIColor.redColor()
    @IBInspectable public var secondsLength: CGFloat = 0.8
    @IBInspectable public var secondsThickness: CGFloat = 1
    @IBInspectable public var secondsOffset: CGFloat = 2
    
    private var sideLength: CGFloat = 0
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // Place subviews according to values for hour minutes seconds
        sideLength = min(self.bounds.size.width, self.bounds.size.height)
        
        // Reset all transforms
        setuphand(handHours, lengthRatio: hoursLength, thickness: hoursThickness, offset: hoursOffset)
        setuphand(handMinutes, lengthRatio: minutesLength, thickness: minutesThickness, offset: minutesOffset)
        setuphand(handSeconds, lengthRatio: secondsLength, thickness: secondsThickness, offset: secondsOffset)
        
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
    
    private func setuphand(hand: UIView, lengthRatio: CGFloat, thickness: CGFloat, offset: CGFloat) {
        hand.layer.transform = CATransform3DIdentity
        
        let handLength = (sideLength/2) * lengthRatio

        let anchorX: CGFloat = 0.5
        let anchorY: CGFloat = 1.0 - (offset/handLength)
        hand.layer.anchorPoint = CGPoint(x: anchorX, y: anchorY)
        
        let centerInParent = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        hand.frame = CGRectMake(centerInParent.x-(thickness/2), centerInParent.y - handLength + offset, thickness, handLength)
    }
    
    private func setTime(#h: Int, m: Int, s: Int) {
        
        // Put everything in seconds to have ratios
        let hoursInSeconds = (h%12)*3600
        let minutesInSeconds = (m%60)*60
        let secondsInSeconds = (s%60)
        
        let hoursRatio = CGFloat(hoursInSeconds + minutesInSeconds + secondsInSeconds) / 43200.0
        let minutesRatio = CGFloat(minutesInSeconds + secondsInSeconds) / 3600.0
        let secondsRatio = CGFloat(secondsInSeconds) / 60.0
        
        handSeconds.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI)*secondsRatio)
        handMinutes.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI)*minutesRatio)
        handHours.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI)*hoursRatio)
    }

}
