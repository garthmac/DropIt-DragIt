//
//  DropItViewController.swift
//  DropIt DragIt
//
//  Created by iMac 27 on 2015-10-29.
//  Copyright © 2015 iMac 27. All rights reserved.
//

import UIKit

class DropItViewController: UIViewController, UIDynamicAnimatorDelegate {

    @IBOutlet weak var gameView: BezierPathView!
    lazy var animator: UIDynamicAnimator = {
        let lazyCreatedDynamicAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazyCreatedDynamicAnimator.delegate = self
        return lazyCreatedDynamicAnimator
    }()
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
//        removeCompletedRow()
    }
    let dropItBehavior = DropItBehavior()
    struct PathNames {
        static let Attachment = "Attachment"
        static let LineBarrier = "Line Barrier"
        static let MiddleBarrier = "Middle Barrier"
        static let RightOvalBarrier = "Right Oval Barrier"
        static let LeftOvalBarrier = "Left Oval Barrier"
    }
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(dropItBehavior)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let offset = CGFloat(50)
        var barrierSize = dropSize
        var barrierOrigin = CGPoint(x: gameView.bounds.midX - barrierSize.width / 2, y: gameView.bounds.midY - barrierSize.height / 2)
        let path = UIBezierPath(roundedRect: CGRect(origin: barrierOrigin, size: dropSize), cornerRadius: 10.0)
        path.lineWidth = 4
//        let path = UIBezierPath(ovalInRect: CGRect(origin: barrierOrigin, size: barrierSize))
        //comment next line to hide barrier
        gameView.setPath(path, named: PathNames.MiddleBarrier)
        dropItBehavior.addBarrier(path, named: PathNames.MiddleBarrier)
        
//        barrierOrigin = CGPoint(x: gameView.bounds.midX, y: gameView.bounds.maxY)
//        let path2 = UIBezierPath(arcCenter: gameView.bounds.origin, radius: gameView.bounds.width, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
//        barrierOrigin = CGPoint(x: gameView.bounds.midX, y: gameView.bounds.maxY)
//        let path2 = UIBezierPath(arcCenter: barrierOrigin, radius: gameView.bounds.width/4, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: false)
        
        barrierOrigin = CGPoint(x: gameView.bounds.midX, y: gameView.bounds.midY)
        let path2 = UIBezierPath(ovalInRect: CGRect(origin: barrierOrigin, size: gameView.bounds.size))
        path2.lineWidth = 4
        //comment next line to hide barrier
        gameView.setPath(path2, named: PathNames.RightOvalBarrier)
        dropItBehavior.addBarrier(path2, named: PathNames.RightOvalBarrier)
        
        barrierOrigin = CGPoint(x: -gameView.bounds.midX-offset, y: gameView.bounds.midY/2)
        let path3 = UIBezierPath(ovalInRect: CGRect(origin: barrierOrigin, size: gameView.bounds.size))
        path3.lineWidth = 4
        //comment next line to hide barrier
        gameView.setPath(path3, named: PathNames.LeftOvalBarrier)
        dropItBehavior.addBarrier(path3, named: PathNames.LeftOvalBarrier)
        
        barrierSize = CGSize(width: dropSize.width, height: dropSize.height*16)
        barrierOrigin = CGPoint(x: gameView.bounds.midX/2 + offset/2, y: gameView.bounds.midY/2)
//        let path4 = UIBezierPath(rect: CGRect(origin: barrierOrigin, size: barrierSize))
        let path4 = UIBezierPath(arcCenter: barrierOrigin, radius: 100, startAngle: 0.0, endAngle: CGFloat(M_PI * 0.75), clockwise: true)
        path4.closePath()
//        path4.appendPath(UIBezierPath(arcCenter: barrierOrigin, radius: 200, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: false))
//        path4.addLineToPoint(CGPointZero)
        path4.lineWidth = 4
//        path4.addLineToPoint(CGPoint(x: barrierOrigin.x+40, y: barrierOrigin.y))
//        path4.addLineToPoint(CGPointZero)
//        path4.moveToPoint(CGPoint(x: 0, y: gameView.bounds.maxY))
//        path4.addQuadCurveToPoint(barrierOrigin, controlPoint: CGPointZero)
        //path4.lineWidth = 4
        //comment next line to hide barrier
        gameView.setPath(path4, named: PathNames.LineBarrier)
        dropItBehavior.addBarrier(path4, named: PathNames.LineBarrier)
    }
    var dropsPerRow: Int {
        let model = UIDevice.currentDevice().model
        if model.hasPrefix("iPad") {
            return 20
            }
            else { return 10 }
    }
    var dropSize: CGSize {
        let w =  CGFloat(40.0)   //gameView.bounds.size.width / CGFloat(dropsPerRow)
        let h =  w   //gameView.bounds.size.height / CGFloat(dropsPerRow)
        return CGSize(width: w, height: h)
    }
    var attachment: UIAttachmentBehavior? {
        willSet {
            if attachment != nil {
                animator.removeBehavior(attachment!)
            }
            gameView.setPath(nil, named: PathNames.Attachment)
        }
        didSet {
            if attachment != nil {
                animator.addBehavior(attachment!)
                attachment?.action = { [unowned self] in
                    if let attachedView = self.attachment?.items.first as? UIView {
                        let path = UIBezierPath()
                        path.moveToPoint(self.attachment!.anchorPoint)
                        path.addLineToPoint(attachedView.center)
                        self.gameView.setPath(path, named: PathNames.Attachment)
                    }
                }
            }
        }
    }
    var lastDroppedView: UIView?
    @IBAction func grabDrop(sender: UIPanGestureRecognizer) {
        let gesturePoint = sender.locationInView(gameView)
        switch sender.state {
        case .Began:
            if let viewToAttachTo = lastDroppedView {
//                attachment = UIAttachmentBehavior(item: viewToAttachTo, attachedToAnchor: gesturePoint)
                attachment = UIAttachmentBehavior(item: viewToAttachTo, offsetFromCenter: UIOffset(horizontal: 5.0, vertical: 5.0), attachedToAnchor: gesturePoint)
                lastDroppedView = nil //so cannot pan/attach to again
            }
        case .Changed:
            attachment?.anchorPoint = gesturePoint
        case .Ended:
            attachment = nil
        default: break
        }
    }
    @IBAction func drop(sender: UITapGestureRecognizer) {
        drop()
    }
    func drop() {
        var frame = CGRect(origin: CGPointZero, size: dropSize)
        frame.origin.x = CGFloat.random(dropsPerRow) * dropSize.width
//        let dropView = Oval(frame: frame)
//        dropView.backgroundColor = UIColor.whiteColor()
        let dropView = UIView(frame: frame)
        dropView.backgroundColor = UIColor(patternImage: UIImage(named: "Icon-Small-40.png")!)
        dropView.layer.cornerRadius = CGFloat(10.0)
        dropView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        dropView.layer.shadowOpacity = 0.5
        lastDroppedView = dropView
        dropItBehavior.addDrop(dropView)
    }
}

private extension CGFloat {
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}