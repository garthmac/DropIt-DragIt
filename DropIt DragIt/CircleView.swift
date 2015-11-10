//
//  CircleView.swift
//  DragIt
//
//  Created by iMac 27 on 2015-10-16.
//  Copyright © 2015 iMac 27. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    let model = UIDevice.currentDevice().model
    var ballOffset: CGFloat = 10.0
    var circleLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        if model.hasPrefix("iPad") {
            ballOffset = 0
        }
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle. //startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0)
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - ballOffset)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        //just change the startAngle: and endAngle: parameters of the UIBezierPath. 0 is the 3 position, so the 12 position would be 90° less than that, which is -π/2 in radians. So, the parameters would be startAngle: CGFloat(-M_PI_2), endAngle: CGFloat((M_PI * 2.0) - M_PI_2)
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = UIColor.greenColor().CGColor
        circleLayer.lineWidth = 4.0
        // Don't draw the circle initially
        circleLayer.strokeEnd = 0.0
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func animateCircle(duration: NSTimeInterval) {
        circleLayer.strokeColor = UIColor.whiteColor().CGColor
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        // Set the animation duration appropriately
        animation.duration = duration
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1.0
        // Do the actual animation
        circleLayer.addAnimation(animation, forKey: "animateCircle")
    }
    func animateEraseCircle(duration: NSTimeInterval) {
        circleLayer.strokeColor = UIColor.lightGrayColor().CGColor
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        // Set the animation duration appropriately
        animation.duration = duration
        // Animate from... 1 (full circle) to 0 (no circle)
        animation.fromValue = 1
        animation.toValue = 0
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1.0
        circleLayer.lineWidth = 1.5
        // Do the actual animation
        circleLayer.addAnimation(animation, forKey: "animateEraseCircle")
    }
    convenience init(frame: CGRect, ballColor: CGColor) {
        self.init(frame: frame)
        circleLayer.fillColor = ballColor
    }
//    override func drawRect(rect: CGRect) {
//        // Get the Graphics Context
//        var context = UIGraphicsGetCurrentContext()
//        // Set the circle outerline-width
//        CGContextSetLineWidth(context, 5.0)
//        // Set the circle outerline-colour
//        UIColor.redColor().set()
//        // Create Circle
//        CGContextAddArc(context, (frame.size.width)/2, frame.size.height/2, (frame.size.width - 10)/2, 0.0, CGFloat(M_PI * 2.0), 1)
//        // Draw
//        CGContextStrokePath(context)
//    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
