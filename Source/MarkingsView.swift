//
//  MarkingsView.swift
//  EZClockView
//
//  Created by Benoit Layer on 21/04/2015.
//  Copyright (c) 2015 Benoit Layer. All rights reserved.
//

import UIKit

internal class MarkingsView: UIView {

    // Margin from the border of the clock.
    internal var borderSpacing: CGFloat = 20 { didSet { setNeedsDisplay() } }
    
    // Length in points of the hour markings.
    internal var hourMarkingLength: CGFloat = 20 { didSet { setNeedsDisplay() } }
    internal var hourMarkingThickness: CGFloat = 1 { didSet { setNeedsDisplay() } }
    internal var hourMarkingColor: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() } }
    
    // Length in points of the minute markings.
    internal var minuteMarkingLength: CGFloat = 10 { didSet { setNeedsDisplay() } }
    internal var minuteMarkingThickness: CGFloat = 1 { didSet { setNeedsDisplay() } }
    internal var minuteMarkingColor: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() } }
    
    internal var shouldDrawHourMarkings: Bool = true { didSet { setNeedsDisplay() } }
    internal var shouldDrawMinuteMarkings: Bool = true { didSet { setNeedsDisplay() } }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required internal init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
    
    override internal func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextClearRect(context, rect)
        CGContextSetAllowsAntialiasing(context, true)
        CGContextSetShouldAntialias(context, true)
        CGContextSaveGState(context)
        
        // Get the size of the clock (a square at the center of the rect)
        let size = min(rect.size.width, rect.size.height)
        let lineLength = size/2 - borderSpacing
        let center = CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMidY(rect))
        
        // Draw 12 hour marks
        let hourOffsetAngle: CGFloat = CGFloat(M_PI/6.0)
        let hourPath = CGPathCreateMutable()
        CGPathMoveToPoint(hourPath, nil, center.x, center.y)
        for i in 0..<12 {
            let x = center.x + lineLength * sin(CGFloat(i) * hourOffsetAngle)
            let y = center.y - lineLength * cos(CGFloat(i) * hourOffsetAngle)
            CGPathAddLineToPoint(hourPath, nil, x, y)
            CGPathMoveToPoint(hourPath, nil, center.x, center.y)
        }
        
        // Clip for hours
        let hoursMaskRadius = lineLength - hourMarkingLength
        CGContextBeginPath(context)
        CGContextAddRect(context, CGContextGetClipBoundingBox(context))
        CGContextAddEllipseInRect(context, CGRect(origin: CGPoint(x: center.x - hoursMaskRadius, y: center.y - hoursMaskRadius), size: CGSize(width: hoursMaskRadius*2, height: hoursMaskRadius*2)))
        CGContextEOClip(context)
        
        // Draw hour markings
        if shouldDrawHourMarkings {
            hourMarkingColor.set()
            CGContextSetLineWidth(context, hourMarkingThickness)
            CGContextAddPath(context, hourPath)
            CGContextStrokePath(context)
        }
        CGContextRestoreGState(context)
        
        CGContextSaveGState(context)
        
        let minuteOffsetAngle: CGFloat = CGFloat(M_PI/30.0)
        let minutePath = CGPathCreateMutable()
        for i in 0...61 {
            if (i % 5 != 0) { // Minutes markings do not overlap hours markings
                let x = center.x + lineLength * sin(CGFloat(i) * minuteOffsetAngle)
                let y = center.y - lineLength * cos(CGFloat(i) * minuteOffsetAngle)
                CGPathAddLineToPoint(minutePath, nil, x, y)
                CGPathMoveToPoint(minutePath, nil, center.x, center.y)
            }
        }
        
        // Clip for minutes
        let minutesMaskRadius = lineLength - minuteMarkingLength
        CGContextBeginPath(context)
        CGContextAddRect(context, CGContextGetClipBoundingBox(context))
        CGContextAddEllipseInRect(context, CGRect(origin: CGPoint(x: center.x - minutesMaskRadius, y: center.y - minutesMaskRadius), size: CGSize(width: minutesMaskRadius*2, height: minutesMaskRadius*2)))
        CGContextEOClip(context)

        // Draw minute markings
        if shouldDrawMinuteMarkings {
            minuteMarkingColor.set()
            CGContextSetLineWidth(context, minuteMarkingThickness)
            CGContextAddPath(context, minutePath)
            CGContextStrokePath(context)
        }
        CGContextRestoreGState(context)
        // ---------------
    }

}
