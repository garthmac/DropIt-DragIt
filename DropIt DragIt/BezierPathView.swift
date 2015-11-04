//
//  BezierPathView.swift
//  DropIt DragIt
//
//  Created by iMac 27 on 2015-10-29.
//  Copyright © 2015 iMac 27. All rights reserved.
//

import UIKit

class BezierPathView: UIView {

    private var bezierPaths = [String:UIBezierPath]()
    
    func setPath(path: UIBezierPath?, named name: String) {
        bezierPaths[name] = path
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        for (_, path) in bezierPaths {
            path.stroke()
        }
    }
}
