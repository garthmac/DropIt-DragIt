//
//  Oval.swift
//  DropIt3
//
//  Created by iMac21.5 on 4/30/15.
//  Copyright (c) 2015 Garth MacKenzie. All rights reserved.
//

import UIKit

class Oval: UIView {
    
    var fillColor: UIColor = UIColor.random
    var isPlus = 1
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(ovalInRect: rect)
        fillColor.setFill()
        path.fill()
        //        path.lineWidth = 3.0
        //        let color = UIColor.blueColor()
        //        color.set()
        //        path.stroke()
        
        //for the horizontal stroke
        let plusHeight: CGFloat = 3.0
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
        let plusPath = UIBezierPath()
        plusPath.lineWidth = plusHeight
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.moveToPoint(CGPoint(x:bounds.width/2 - plusWidth/2 + 0.5,
                                     y:bounds.height/2 + 0.5))
        //add a point to the path at the end of the stroke
        plusPath.addLineToPoint(CGPoint(x:bounds.width/2 + plusWidth/2 + 0.5,
                                        y:bounds.height/2 + 0.5))
        isPlus = fillColor.hashValue / 100000000
        if isPlus > 0 {
            //move to the start of the vertical stroke
            plusPath.moveToPoint(CGPoint(x:bounds.width/2 + 0.5,
                                         y:bounds.height/2 - plusWidth/2 + 0.5))
            //add the end point to the vertical stroke
            plusPath.addLineToPoint(CGPoint(x:bounds.width/2 + 0.5,
                                            y:bounds.height/2 + plusWidth/2 + 0.5))
        }
        UIColor.blackColor().setStroke()
        plusPath.stroke()
    }
}

private extension UIColor {
    class var random: UIColor {
        switch arc4random() % 10 {
        case 0: return UIColor.greenColor()
        case 1: return UIColor.blueColor()
        case 2: return UIColor.orangeColor()
        case 3: return UIColor.redColor()
        case 4: return UIColor.purpleColor()
        case 5: return UIColor.yellowColor()
        case 6: return UIColor.brownColor()
        case 7: return UIColor.darkGrayColor()
        case 8: return UIColor.lightGrayColor()
        case 9: return UIColor.cyanColor()
        default: return UIColor.blackColor()
        }
    }
}