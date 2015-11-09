//
//  DragItViewController.swift
//  DragIt
//
//  Created by iMac 27 on 2015-10-15.
//  Copyright © 2015 iMac 27. All rights reserved.
//

import UIKit
import AVFoundation

func degreesToRadians(degrees: Double) -> CGFloat {
    return CGFloat(degrees * M_PI / 180.0)
}
func radiansToDegrees(radians: Double) -> CGFloat {
    return CGFloat(radians / M_PI * 180.0)
}

class DragItViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var dragAreaView: UIView!
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var dragHereLabel: UILabel!
    @IBOutlet weak var dragView: UIView!
    @IBOutlet weak var dragViewXLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var dragViewYLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowCenterYLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var demoButton: UIButton!
    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    struct Constants {
        static let BonusTime = 12
        static let CreditsSegue = "Credits View"
        static let DropItSegue = "DropIt View"
        static let ShopSegue = "SHOP View"
        static let DragItDemoURL = "https://player.vimeo.com/video/143505343?autoplay=1"
        static let Demo2URL = "https://player.vimeo.com/video/141500688?autoplay=1"
        static let Demo3URL = "https://player.vimeo.com/video/141498589?autoplay=1"
        static let MarketingURL = "https://redblockblog.wordpress.com/marketing/"
        static let MoveUpDown = "Verticle"
        static let MoveLeftRight = "Horizontal"
    }
    let model = UIDevice.currentDevice().model
    var maxDifficulty = 75
    var circleViewDict = [String:CircleView]()
    let videoTags = ["A", "B", "C", "D", "E", "F", "G", "H", "I"]
    let degrees: [Double] = [270, 310, 350, 30, 70, 110, 150, 190, 230]
    var url: NSURL?
    var creditsURL: NSURL?
    @IBAction func demo(sender: UIButton?) {
        if url != nil {
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    func demo3(sender: UIButton?) {
        if creditsURL != nil {
            UIApplication.sharedApplication().openURL(creditsURL!)
        }
    }
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.ShopSegue:
                if let svc = segue.destinationViewController as? ShopViewController {
                    svc.backDrops = backDrops
                    svc.backDropImages = backDropImages
                    svc.ballSkins = ballSkins
                    svc.ballImages = ballImages
                    svc.doneLoad = doneLoad
                }
            case Constants.CreditsSegue:
                let ivc = segue.destinationViewController
                //prepare
                for view in ivc.view.subviews {
                    if let animatedImageView = view as? UIImageView {
                        if animatedImageView.tag == 111 {
                            let images = (0...8).map {
                                UIImage(named: "peanuts-anim\($0).png")!
                            }
                            animatedImageView.animationImages = images
                            animatedImageView.animationDuration = 9.0
                            //animatedImageView.animationRepeatCount = 0 //0 repeat indefinitely is default
                            animatedImageView.startAnimating()
                        }
                    }
                }
            default:
                break
            }
        }
    }
    @IBAction func showCredits(sender: UIButton) {
        creditsAction(sender)
    }
    func creditsAction(sender: UIButton) {
        //print("Button tapped")
        self.performSegueWithIdentifier(Constants.CreditsSegue, sender: sender)
    }
    @IBAction func shop(sender: UIButton) {
        spinner?.startAnimating()
        performSegueWithIdentifier(Constants.ShopSegue, sender: nil)
    }
    @IBAction func unwindFromModalViewController(segue: UIStoryboardSegue) {
        //drag from back button to viewController exit button <--SHOP
        spinner?.stopAnimating()
    }
    @IBAction func unwindFromModalCREDITSViewController(segue: UIStoryboardSegue) {
        //drag from back button to viewController exit button <--Demo
        demo3(nil)
    }
    @IBAction func unwindFromModalCREDITS2ViewController(segue: UIStoryboardSegue) {
        //drag from back button to viewController exit button <--Back
    }
    func rotateView(view: UIView, degrees: CGFloat) {
        let delay = 2.0 * Double(NSEC_PER_SEC)
        if degrees <= 180.0 {
            let deg1 = degrees
            UIView.animateWithDuration(2.0, animations: {
                view.transform = CGAffineTransformMakeRotation((deg1 * CGFloat(M_PI)) / 180.0)
            })
        } else {
            let deg2 = 360.0 - degrees
            UIView.animateWithDuration(2.0, animations: {
                view.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
            })
            UIView.animateWithDuration(2.0, animations: {
                view.transform = CGAffineTransformMakeRotation((deg2 * CGFloat(M_PI)) / 180.0)
            })
        }
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) { [weak self] (success) -> Void in
            self!.boundsChanged()  //added
            self!.level += 1
            self!.earnCoin()
        }
        if level % 2 == 0 {
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) { [weak self] (success) -> Void in
                self!.performSegueWithIdentifier(Constants.DropItSegue, sender: nil)   //--> bonus segue
            }
        }
        for (_,circle) in circleViewDict {
            UIView.animateWithDuration(2.0, animations: {
                circle.center = self.translatedGoalCenter
                circle.alpha = 0
            })
        }
    }
    func pointOnCircleEdge(radius: CGFloat, angleInDegrees: Double) -> CGPoint {
        let center = CGPoint(x: CGRectGetMidX(view!.bounds), y: CGRectGetMidY(view!.bounds) )
        let x = center.x + (radius * cos(degreesToRadians(angleInDegrees)))
        let y = center.y + (radius * sin(degreesToRadians(angleInDegrees)))
        return CGPoint(x: x, y: y)
    }
    func addCircleView(index: Int) {
        let circleWidth = CGFloat(40)   //(25 + (arc4random() % 50))
        let circleHeight = circleWidth
        //start at bottom = 270 degrees
        let centerPoint = pointOnCircleEdge(ringView!.bounds.width/2, angleInDegrees: degrees[index])
        // Create a new CircleView
        var ballColor = UIColor.blueColor().CGColor
        if Settings().purchasedUid != "perfect_bubble40" {
            if let image = UIImage(named: Settings().purchasedUid!) {
                ballColor = UIColor(patternImage: image).CGColor
            }
        }
        let circleView = CircleView(frame: CGRectMake(centerPoint.x - circleWidth/2, centerPoint.y - circleWidth/2, circleWidth, circleHeight), ballColor: ballColor)
        circleViewDict[videoTags[index]] = circleView
        view.addSubview(circleView)
    }
    var initialDragViewY: CGFloat = 30.0
    var isGoalReached: Bool {
        get {
            let rectOrigin = CGPoint(x: (self.translatedGoalCenter.x-27.5), y: (self.translatedGoalCenter.y-27.5))  // goal95/2 - drag40/2
            return CGRectContainsPoint(CGRect(origin: rectOrigin, size: CGSize(width: 55, height: 55)), self.dragView.center)  //95 -40
        }
    }
    let dragAreaPadding = 5
    var lastBounds = CGRectZero
    var ringView: UIView?
    var backDropImages: [UIImage]?
    var ballImages: [UIImage]?
    var doneLoad = false
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //printFonts()
        prepareAudios()
        if !model.hasPrefix("iPad") {
            maxDifficulty = 49
        }
        url = NSURL(string: Constants.DragItDemoURL)
        creditsURL = NSURL(string: Constants.Demo3URL)
        lastBounds = self.view.bounds
        let diameter = min(view.frame.maxX, view.frame.maxY) - 50.0
        ringView = UIView(frame: CGRect(origin: goalView.center, size: CGSize(width: diameter, height: diameter)))
        ringView!.layer.borderColor = UIColor.greenColor().CGColor       //change to green to see
        ringView!.layer.cornerRadius = ringView!.bounds.size.width / 2   //new
        ringView!.layer.borderWidth = 4                                  //new
        dragView.layer.cornerRadius = 10
        goalView.layer.cornerRadius = self.goalView.bounds.size.width / 2
        goalView.layer.borderWidth = 4
        initialDragViewY = self.dragViewYLayoutConstraint.constant
        updateGoalView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if Settings().soundChoice != soundTrack {
            audioPlayer.pause()
            prepareAudios()
        }
        if Settings().soundOn {
            audioPlayer.play()
        } else {
            audioPlayer.pause()
        }
        coinCount = 0
        coins.image = nil
        earnCoin()  //fresh coins (only get credit for each 3 coins per game) not a bug
        for i in 0..<backDrops.count {
            if backDrops[i] == Settings().mybackDrops.last {
                backDropImageView.image = UIImage(named: self.backDrops[i])
            }
        }
        setAutoStartTimer()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addBalls()
        if ballImages == nil {
            let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
            dispatch_async(backgroundQueue, { [weak self] in
                print("This is run on the background queue")
                self!.ballImages = (0..<self!.ballSkins.count).map {
                    UIImage(named: self!.ballSkins[$0])!
                }
                self!.backDropImages = (0..<self!.backDrops.count).map {
                    UIImage(named: self!.backDrops[$0])!
                }
                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                    print("This is run on the main queue, after backgroundQueue code in outer closure...doneLoad = true")
                    self!.doneLoad = true
                    })
                })
        }
    }
    func addBalls() {
        for idx in 0..<9 {
            addCircleView(idx)
        }
        //print(circleViewDict)
    }
    func removeBalls() {
        for circle in circleViewDict.values {
            circle.removeFromSuperview()
        }
        for letter in videoTags {
            circleViewDict[letter] = nil
        }
        //print(circleViewDict)
    }
    //To start goalView moving automatically, add a timer which periodically checks, if there is a moveDirection set and push if necessary.
    private var autoStartTimer: NSTimer?
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //remove the timer when a game hides, and start it again afterwards...
        autoStartTimer?.invalidate()
        autoStartTimer = nil
        if Settings().soundOn {
            audioPlayer.pause()
        }
        removeBalls()
    }
    // MARK: - autoStartTimer
    //The timer will be started only when the configuration is set to do so:
    private func setAutoStartTimer() {
        if Settings().autoStart {
            autoStartTimer =  NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "fireAutoStart:", userInfo: nil, repeats: true)
        }
    }
    var level = 1
    var difficulty = 2
    var ctr = 1
    var ctr2 = CGFloat(1)
    var ctr3 = CGFloat(1)
    var translatedGoalCenter = CGPoint()
    func fireAutoStart(timer: NSTimer) {
        if Settings().moveDirection == Constants.MoveUpDown {
            UIView.animateWithDuration(2.0, animations: {
                self.goalView.transform = CGAffineTransformMakeTranslation(self.ctr2 * 5 * CGFloat(self.ctr), self.ctr3 * 10 * CGFloat(self.ctr))
                self.translatedGoalCenter = CGPoint(x: (self.goalView.center.x + self.goalView.transform.tx), y: (self.goalView.center.y + self.goalView.transform.ty))
            })
        }
        if ctr > 0 {
            ctr -= difficulty
        } else if ctr <= 0 { //got stuck at 0 once
            ctr += difficulty
        }
        if abs(ctr) % 2 == 0 {
            ctr2 = -1 * ctr2
        } else {
            ctr3 = -1 * ctr3
        }
        //print("level=\(level) difficulty=\(difficulty) ctr=\(ctr) ctr2=\(ctr2) ctr3=\(ctr3)")   //debug**
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !CGRectEqualToRect(self.view.bounds, self.lastBounds) {
            boundsChanged()
            lastBounds = self.view.bounds
        }
    }
    func boundsChanged() {
        returnToStartLocationAnimated(false)
        dragAreaView.bringSubviewToFront(dragView)
        dragAreaView.bringSubviewToFront(goalView)
        view.layoutIfNeeded()
//        arrowCenterYLayoutConstraint.constant = 0
        resetCoins()
        removeBalls()
        addBalls()
    }
    // MARK: Actions
    @IBAction func panAction() {
        if panGesture.state == .Changed {
            moveObject()
        }
        else if panGesture.state == .Ended {
            if isGoalReached {
                returnToStartLocationAnimated(false)
                moveObject()   //resets goalLabel
                rotateView(goalView, degrees: 360.0)  //--> performSegue
            } else {
                returnToStartLocationAnimated(true)
                updateGoalView()   //resets goalLabel if white
            }
        }
    }
    var videoTag = "Z"
    // checks for taps on circles
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // tapping a circle toggles its state...set dragView
        for touch in touches {
            if let _ = touch.view as? CircleView {
                //print("touch green")
                let point = touch.locationInView(view)
                for (key,circle) in circleViewDict {
                    if circle.frame.contains(point) {
                        if videoTag != key {
                            if videoTag != "Z" {
                                circleViewDict[videoTag]!.animateEraseCircle(2.0)
                            }
                            videoTag = key
//                            NSUserDefaults.standardUserDefaults().setObject(videoTag, forKey: BouncerViewController.Constants.FavVideo)
                            circle.animateCircle(2.0)
                        }
                    }
                }
            }
        }
    }
    // MARK: UI Updates
    func moveObject() {
        let minX = CGFloat(self.dragAreaPadding)
        let maxX = self.dragAreaView.bounds.size.width - self.dragView.bounds.size.width - minX
        let minY = CGFloat(self.dragAreaPadding)
        let maxY = self.dragAreaView.bounds.size.height - self.dragView.bounds.size.height - minY
        var translation =  self.panGesture.translationInView(self.dragAreaView)
        var dragViewX = self.dragViewXLayoutConstraint.constant + translation.x
        var dragViewY = self.dragViewYLayoutConstraint.constant + translation.y
        if abs(dragViewX) > maxX {
            dragViewX = maxX
            translation.x += self.dragViewXLayoutConstraint.constant - maxX
        }
        else {
            translation.x = 0
        }
        if dragViewY < minY {
            dragViewY = minY
            translation.y += self.dragViewYLayoutConstraint.constant - minY
        }
        else if dragViewY > maxY {
            dragViewY = maxY
            translation.y += self.dragViewYLayoutConstraint.constant - maxY
        }
        else {
            translation.y = 0
        }
        self.dragViewXLayoutConstraint.constant = dragViewX
        self.dragViewYLayoutConstraint.constant = dragViewY
        self.panGesture.setTranslation(translation, inView: self.dragAreaView)
        UIView.animateWithDuration(0.05, delay: 0.0, options: .BeginFromCurrentState,
            animations: { () -> Void in
                self.view.layoutIfNeeded()
            },
            completion: nil)
        self.updateGoalView()
    }
    func updateGoalView() {
        let goalColor = self.isGoalReached ? UIColor.whiteColor() : UIColor.redColor()     //(red: 174/255.0, green: 0, blue: 0, alpha: 1)
        self.goalView.layer.borderColor = goalColor.CGColor
        self.dragHereLabel.textColor = goalColor
        self.dragHereLabel.text = self.isGoalReached ? "Drop!" : "Drag here!"
        if difficulty < maxDifficulty {
            difficulty += 1
        } else {
            difficulty = 9
        }
    }
    func returnToStartLocationAnimated(animated: Bool) {
        self.dragViewXLayoutConstraint.constant = self.dragView.bounds.size.width
        self.dragViewYLayoutConstraint.constant = self.initialDragViewY
        if animated {
            UIView.animateWithDuration(0.3, delay: 0, options: .BeginFromCurrentState,
                animations: { () -> Void in
                    self.view.layoutIfNeeded()
                },
                completion: nil)
        }
    }
    let backDrops = [
        "aurora-6-iss-150318.jpg",
        "Black_hole2048.jpg",
        "bluePlanet.jpg",
        "Clouds_outer_space_planets_earth.jpg",
        "digital_art_1024x1024.jpg",
        "glory.jpg",
        "heavensDeclare.jpg",
        "IMG_3562.jpg",
        "Outer_space_planets_earth_men_fantasy.jpg",
        "space_3d_art_planet_earth_apocalyptic.jpg",
        "sunrise_glory-wide.jpg"
    ]
    let ballSkins = [
        "arrow40",
        "asian40",
        "balloonRing40",
        "bluePlanet40",
        "burning40",
        "cufi40",
        "edd40",
        "globe40",
        "vectorA40",
        "vectorB40"
    ]
    // MARK: - get coins!
    lazy var coins: UIImageView = {
        let size = CGSize(width: 42.0, height: 20.0)
        let coins = UIImageView(frame: CGRect(origin: CGPoint(x: -1 , y: -1), size: size))
        self.view.addSubview(coins)
        return coins
    }()
    private var coinCount = 0
    lazy var coinCountLabel: UILabel = { let coinCountLabel = UILabel(frame: CGRect(origin: CGPoint(x: -1 , y: -1), size: CGSize(width: 80.0, height: 20.0)))
        coinCountLabel.font = UIFont(name: "ComicSansMS-Bold", size: 18.0)
        coinCountLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(coinCountLabel)
        return coinCountLabel
    }()
    lazy var largeCoin: UIImageView = {
        let size = CGSize(width: 100.0, height: 100.0)
        let coin = UIImageView(frame: CGRect(origin: CGPoint(x: -1 , y: -1), size: size))
        self.view.addSubview(coin)
        return coin
    }()
    func resetCoins() {
        let midx = view.bounds.midX
        coins.center = CGPoint(x: (midx - 60.0), y: (view.bounds.minY + 12.0))
        coinCountLabel.center = CGPoint(x: (midx + 60.0), y: (view.bounds.minY + 10.0))
        largeCoin.center = CGPoint(x: midx, y: view.bounds.midY)
    }
    func earnCoin() {  //show available credits
        self.coinCount += 1
        if self.coinCount % 3 == 0 {  //move first because of annimation delay
            Settings().availableCredits += 1
        }
        //prepare for annimation
        largeCoin.image = UIImage(named: "1000CreditsSWars1.png")
        largeCoin.alpha = 1
        largeCoin.center.y = view.bounds.minY //move off screen but alpha = 1
        UIView.animateWithDuration(3.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
            self.resetCoins()
            self.largeCoin.alpha = 0
            }, completion: nil)
        //prepare for annimation
        coinCountLabel.alpha = 0
        coinCountLabel.center.y = view.bounds.maxY //move off screen
        let images = (0...2).map {
            UIImage(named: "1000Credits\($0)-20.png") as! AnyObject
        }
        if let image = images[min(coinCount - 1, 2)] as? UIImage {
            coins.image = image
            coins.alpha = 0
            coins.center.y = view.bounds.maxY //move off screen
            let offset = coinCount == 3 ? 0 : min(self.coinCount, 2)
            UIView.animateWithDuration(4.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
                self.coinCountLabel.text = (Settings().availableCredits * 3 + offset).addSeparator
                self.resetCoins()
                self.coins.alpha = 1
                self.coinCountLabel.alpha = 1
                }, completion: nil)
        }
    }
    private var audioPlayer: AVAudioPlayer!
    private var path: String! = ""
    private var soundTrack = 0
    func prepareAudios() {
        soundTrack = Settings().soundChoice
        switch soundTrack {
        case 0: path = NSBundle.mainBundle().pathForResource("jazzloop2_70", ofType: "mp3")
        case 1: path = NSBundle.mainBundle().pathForResource("CYMATICS- Science Vs. Music - Nigel Stanford-2", ofType: "mp3")
        case 2: path = NSBundle.mainBundle().pathForResource("Phil Wickham-Carry My Soul(Live at RELEVANT)", ofType: "mp3")
        case 3: path = NSBundle.mainBundle().pathForResource("Hudson - Chained", ofType: "mp3")
        case 4: path = NSBundle.mainBundle().pathForResource("Forrest Gump Soundtrack", ofType: "mp3")
        case 5: path = NSBundle.mainBundle().pathForResource("Titanic Soundtrack - Rose", ofType: "mp3")
        case 6: path = NSBundle.mainBundle().pathForResource("Phil Wickham - This Is Amazing Grace", ofType: "mp3")
        case 7: path = NSBundle.mainBundle().pathForResource("Hillsong United - No Other Name - Oceans (Where Feet May Fail)", ofType: "mp3")
        case 8: path = NSBundle.mainBundle().pathForResource("Phil Wickham - At Your Name (Yahweh, Yahweh)", ofType: "mp3")
        case 9: path = NSBundle.mainBundle().pathForResource("Yusuf Islam - Peace Train - OUTSTANDING!-2", ofType: "mp3")
        case 10: path = NSBundle.mainBundle().pathForResource("Titans Spirit(Remember The Titans)-Trevor Rabin", ofType: "mp3")
        default: path = NSBundle.mainBundle().pathForResource("jazzloop2_70", ofType: "mp3")
        }
        let url = NSURL.fileURLWithPath(path!)
        audioPlayer = try? AVAudioPlayer(contentsOfURL: url)
        audioPlayer.delegate = self
        audioPlayer.numberOfLoops = 99 //-1 means continuous
        audioPlayer.prepareToPlay()
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
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
private extension Int {
    var addSeparator: String {
        let nf = NSNumberFormatter()
        nf.groupingSeparator = ","
        nf.numberStyle = NSNumberFormatterStyle.DecimalStyle
        return nf.stringFromNumber(self)!
    }
}


