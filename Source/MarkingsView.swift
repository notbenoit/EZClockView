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

internal class MarkingsView: UIView {
	
	// Margin from the border of the clock.
	internal var borderSpacing: CGFloat = 20 { didSet { setNeedsDisplay() } }
	
	// Length in points of the hour markings.
	internal var hourMarkingLength: CGFloat = 20 { didSet { setNeedsDisplay() } }
	internal var hourMarkingThickness: CGFloat = 1 { didSet { setNeedsDisplay() } }
	internal var hourMarkingColor: UIColor = UIColor.black { didSet { setNeedsDisplay() } }
	
	// Length in points of the minute markings.
	internal var minuteMarkingLength: CGFloat = 10 { didSet { setNeedsDisplay() } }
	internal var minuteMarkingThickness: CGFloat = 1 { didSet { setNeedsDisplay() } }
	internal var minuteMarkingColor: UIColor = UIColor.black { didSet { setNeedsDisplay() } }
	
	internal var shouldDrawHourMarkings: Bool = true { didSet { setNeedsDisplay() } }
	internal var shouldDrawMinuteMarkings: Bool = true { didSet { setNeedsDisplay() } }
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.clear
	}
	
	required internal init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.backgroundColor = UIColor.clear
	}
	
	override internal func draw(_ rect: CGRect) {
		guard let context = UIGraphicsGetCurrentContext() else { return }
		context.clear(rect)
		context.setAllowsAntialiasing(true)
		context.setShouldAntialias(true)
		context.saveGState()
		
		// Get the size of the clock (a square at the center of the rect)
		let size = min(rect.size.width, rect.size.height)
		let lineLength = size/2 - borderSpacing
		let center = CGPoint(x: rect.midX, y: rect.midY)
		
		// Draw 12 hour marks
		let hourOffsetAngle: CGFloat = CGFloat(M_PI/6.0)
		let hourPath = CGMutablePath()
		hourPath.move(to: center)
		for i in 0..<12 {
			let x = center.x + lineLength * sin(CGFloat(i) * hourOffsetAngle)
			let y = center.y - lineLength * cos(CGFloat(i) * hourOffsetAngle)
			hourPath.addLine(to: CGPoint(x: x,y: y))
			hourPath.move(to: center)
		}
		
		// Clip for hours
		let hoursMaskRadius = lineLength - hourMarkingLength
		context.beginPath()
		context.addRect(context.boundingBoxOfClipPath)
		context.addEllipse(in: CGRect(origin: CGPoint(x: center.x - hoursMaskRadius, y: center.y - hoursMaskRadius), size: CGSize(width: hoursMaskRadius*2, height: hoursMaskRadius*2)))
		context.clip(using: CGPathFillRule.evenOdd)
		
		// Draw hour markings
		if shouldDrawHourMarkings {
			hourMarkingColor.set()
			context.setLineWidth(hourMarkingThickness)
			context.addPath(hourPath)
			context.strokePath()
		}
		context.restoreGState()
		
		context.saveGState()
		
		let minuteOffsetAngle: CGFloat = CGFloat(M_PI/30.0)
		let minutePath = CGMutablePath()
		minutePath.move(to: center)
		for i in 0...61 {
			if (i % 5 != 0) { // Minutes markings do not overlap hours markings
				let x = center.x + lineLength * sin(CGFloat(i) * minuteOffsetAngle)
				let y = center.y - lineLength * cos(CGFloat(i) * minuteOffsetAngle)
				minutePath.addLine(to: CGPoint(x: x, y: y))
				minutePath.move(to: center)
			}
		}
		
		// Clip for minutes
		let minutesMaskRadius = lineLength - minuteMarkingLength
		context.beginPath()
		context.addRect(context.boundingBoxOfClipPath)
		context.addEllipse(in: CGRect(origin: CGPoint(x: center.x - minutesMaskRadius, y: center.y - minutesMaskRadius), size: CGSize(width: minutesMaskRadius*2, height: minutesMaskRadius*2)))
		context.clip(using: CGPathFillRule.evenOdd)
		
		// Draw minute markings
		if shouldDrawMinuteMarkings {
			minuteMarkingColor.set()
			context.setLineWidth(minuteMarkingThickness)
			context.addPath(minutePath)
			context.strokePath()
		}
		context.restoreGState()
		// ---------------
	}
	
}
