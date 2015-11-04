//
//  DropItBehavior.swift
//  DropIt DragIt
//
//  Created by iMac 27 on 2015-10-29.
//  Copyright © 2015 iMac 27. All rights reserved.
//

import UIKit

class DropItBehavior: UIDynamicBehavior {
   
    let gravity = UIGravityBehavior()
    lazy var collider: UICollisionBehavior = {
        let lazyCreatedCollider = UICollisionBehavior()
        lazyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        return lazyCreatedCollider
        }()
    lazy var dropBehavior: UIDynamicItemBehavior = {
        let lazyCreatedDropBehavior = UIDynamicItemBehavior()
        lazyCreatedDropBehavior.allowsRotation = true
        lazyCreatedDropBehavior.elasticity = 0.95
        return lazyCreatedDropBehavior
        }()
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(dropBehavior)
    }
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    func addDrop(drop: UIView) {
//        print(dynamicAnimator?.referenceView?.description)
        dynamicAnimator?.referenceView?.addSubview(drop)
        gravity.addItem(drop)
        collider.addItem(drop)
        dropBehavior.addItem(drop)
    }
    func removeDrop(drop: UIView) {
        gravity.removeItem(drop)
        collider.removeItem(drop)
        dropBehavior.removeItem(drop)
        drop.removeFromSuperview()
    }
}
