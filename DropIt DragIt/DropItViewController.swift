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
    @IBOutlet weak var progressView: UIProgressView!
    let model = UIDevice.currentDevice().model
    lazy var animator: UIDynamicAnimator = {
        let lazyCreatedDynamicAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazyCreatedDynamicAnimator.delegate = self
        return lazyCreatedDynamicAnimator
    }()
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        removeBonusBlocks(false)
    }
    func removeBonusBlocks(isAnimated: Bool) {  //blocks up on spoon
        if isAnimated {
            for drop in dropsToRemove {
                //prepare for annimation
                UIView.animateWithDuration(2.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: { [weak self] (success) -> Void in
                    drop.center.x = self!.gameView.frame.maxX + 100
                    }, completion: nil)
            }
        } else {
            sleep(2)
            for drop in dropsToRemove {
                dropItBehavior.removeDrop(drop)
            }
        }
    }
    let dropItBehavior = DropItBehavior()
    struct PathNames {
        static let Attachment = "Attachment"
        static let LineBarrier = "Line Barrier"
        static let MiddleBarrier = "Middle Barrier"
        static let RightOvalBarrier = "Right Oval Barrier"
        static let LeftOvalBarrier = "Left Oval Barrier"
    }
    lazy var scoreBoard: UILabel = { let sb = UILabel(frame: CGRect(origin: CGPoint(x: -1 , y: -1), size: CGSize(width: min(self.gameView.frame.width, self.gameView.frame.height), height: 30.0)))
        sb.text = "Bonus! "
        sb.font = UIFont(name: "ComicSansMS-Bold", size: 34.0)
        sb.textAlignment = NSTextAlignment.Center
        sb.textColor = UIColor.blueColor()
        self.gameView.addSubview(sb)
        return sb
    }()
    func showBonusScore(isBonus: Bool) {
        if isBonus {
            scoreBoard.alpha = 0    //prepare for annimation
            scoreBoard.center.y = 0
            scoreBoard.text?.appendContentsOf("\(score)")
            UIView.animateWithDuration(2.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: { [weak self] (success) -> Void in
                self!.resetScoreBoard()
                self!.scoreBoard.alpha = 1
                }, completion: nil)
        } else {
            scoreBoard.text = ""
        }
    }
    func resetScoreBoard() {
        scoreBoard.center = CGPoint(x: gameView.bounds.midX, y: (gameView.bounds.midY - 50.0))
    }
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(dropItBehavior)
        progressView.progress = 0
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let offset = CGFloat(50)
        let barrierSize = dropSize
        var barrierOrigin = CGPoint(x: gameView.bounds.midX - barrierSize.width / 2, y: gameView.bounds.midY - barrierSize.height / 2)
        let path = UIBezierPath(roundedRect: CGRect(origin: barrierOrigin, size: dropSize), cornerRadius: 10.0)
        path.lineWidth = 4
        //comment next line to hide barrier
        gameView.setPath(path, named: PathNames.MiddleBarrier)
        dropItBehavior.addBarrier(path, named: PathNames.MiddleBarrier)
        
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

        barrierOrigin = CGPoint(x: gameView.bounds.midX/2 + offset/2, y: gameView.bounds.midY/2)
        var r = CGFloat(100)
        if !model.hasPrefix("iPad") {
            r = r - offset
        }
        let path4 = UIBezierPath(arcCenter: barrierOrigin, radius: r, startAngle: 0.0, endAngle: CGFloat(M_PI * 0.75), clockwise: true)
        path4.closePath()
        path4.lineWidth = 4
        //comment next line to hide barrier
        gameView.setPath(path4, named: PathNames.LineBarrier)
        dropItBehavior.addBarrier(path4, named: PathNames.LineBarrier)
    }
    private var bonusProgressTimer: NSTimer?
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        bonusProgressTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "fireBonusProgess:", userInfo: nil, repeats: true)  //fire every 1/2 second
        if Settings().availableCredits > 9 {
            gameView.backgroundColor = UIColor.random
            if gameView.backgroundColor == UIColor.blueColor() {
                scoreBoard.textColor = UIColor.redColor()
            }
        }
    }
    var progressCompleted = false
    func fireBonusProgess(timer: NSTimer) {  //each second, need to call it 1/Settings().bonusTime times
        if progressView.trackTintColor == nil {
            progressView.progress += 0.5/Float(Double(DragItViewController.Constants.BonusTime) * 5/12 + Double(paidExtraSeconds))    // settleDelay = max 10 seconds (min 5)
        }
        if progressView.progress > 0.99 {
            progressCompleted = true
            progressView.tintColor = UIColor.blueColor()  //this change rounds the progressView tint end cap
            progressView.trackTintColor = UIColor.lightGrayColor()  //this change rounds the progressView end cap
        }
        if progressCompleted {
            progressView.progress -= 0.5/Float(Double(DragItViewController.Constants.BonusTime) * 7/12 - Double(paidExtraSeconds))   // totalTime - paidExtension = max 7 seconds (min 2)
        }
    }
    let delay = Double(DragItViewController.Constants.BonusTime) * Double(NSEC_PER_SEC)  //12 seconds
    var tappingOver = false
    var score = 0
    let paidExtraSeconds = Settings().bonusTime - DragItViewController.Constants.BonusTime  //17 - 12 = 5 seconds max
    var dropsToRemove = [UIView]()
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let totalTime = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(delay))  //12 seconds total
        dispatch_after(totalTime, dispatch_get_main_queue()) { [weak self] (success) -> Void in
            self!.dismissViewControllerAnimated(true, completion: nil)
        }
        let tapTimeOver = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(delay*0.25))  //3 seconds
        dispatch_after(tapTimeOver, dispatch_get_main_queue()) { [weak self] (success) -> Void in
            self!.tappingOver = true
        }
        let paidExtension = Double(paidExtraSeconds) * Double(NSEC_PER_SEC)  //allow up to 5 seconds extra time to attach/drag blocks up to spoon
        let settleDelay = delay*5/12 + paidExtension  //12*5/12 + 5 = 10 seconds max
        print(settleDelay)
        let dragTimeAfterTapEnded = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(settleDelay))  //wait for blocks to settle down
        dispatch_after(dragTimeAfterTapEnded, dispatch_get_main_queue()) { [weak self] (success) -> Void in
            for (_,drop) in self!.dropViewDict {
                if drop.frame.origin.y < (self!.gameView.bounds.midY/2 + 100.0) {
                    if drop.frame.origin.x < (self!.gameView.bounds.midX + 100.0) {
                        if CGRectContainsPoint(CGRect(origin: self!.gameView.frame.origin, size: self!.gameView.frame.size), drop.center) {
                            self!.dropsToRemove.append(drop)
                            self!.score += 1
                        }
                    }
                }
            }
            Settings().availableCredits += Int(round(Double(self!.score) / 3.0))  //earn 1 credit(=3 coins) per 3 bonus points (rounded)
            self!.showBonusScore(true)  //show available credits
            self!.removeBonusBlocks(true)  //2 seconds 10 + 2 = 12 max
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //clean up
        for (idx,_) in dropViewDict {
            dropViewDict[idx] = nil
        }
        bonusProgressTimer?.invalidate()
    }
    var dropsPerRow: Int {
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
                        self.attachment?.length = 40
                        self.gameView.setPath(path, named: PathNames.Attachment)
                    }
                }
            }
        }
    }
    var lastDroppedView: UIView?
    var savedDropIndex = 0
    @IBAction func grabDrop(sender: UIPanGestureRecognizer) {
        let gesturePoint = sender.locationInView(gameView)
        switch sender.state {
        case .Began:
            if let viewToAttach = lastDroppedView {
                attachment = UIAttachmentBehavior(item: viewToAttach, attachedToAnchor: gesturePoint)
                lastDroppedView = nil //so cannot pan/attach to again
            } else if let nextViewToAttach = dropViewDict[savedDropIndex] {
                savedDropIndex += 1
                attachment = UIAttachmentBehavior(item: nextViewToAttach, attachedToAnchor: gesturePoint)
            }
        case .Changed:
            attachment?.anchorPoint = gesturePoint
        case .Ended:
            attachment = nil
        default: break
        }
    }
    @IBAction func drop(sender: UITapGestureRecognizer) {
        if !tappingOver {
            drop()
        }
    }
    var dropViewDict = [Int:UIView]()
    var idx = 0
    func drop() {
        var frame = CGRect(origin: CGPointZero, size: dropSize)
        frame.origin.x = CGFloat.random(dropsPerRow) * dropSize.width
        let dropView = UIView(frame: frame)
        dropView.backgroundColor = UIColor(patternImage: UIImage(named: "Icon-Small-40.png")!)
        dropView.layer.cornerRadius = CGFloat(10.0)
        dropView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        dropView.layer.shadowOpacity = 0.5
        dropViewDict[idx] = dropView
        idx += 1
        lastDroppedView = dropView
        dropItBehavior.addDrop(dropView)
    }
}

// MARK: - extensions
private extension UIColor {
    class var random: UIColor {
        switch arc4random() % 11 {
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
        case 10: return UIColor.whiteColor()
        default: return UIColor.clearColor()
        }
    }
}
private extension CGFloat {
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}