//
//  ShopViewController.swift
//  DragIt
//
//  Created by iMac21.5 on 10/20/15.
//  Copyright (c) 2015 Garth MacKenzie. All rights reserved.
//

import UIKit
import AVFoundation

class ShopViewController: UIViewController, AVAudioPlayerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var backdropImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightTrophyImageView: UIImageView!
    @IBOutlet weak var userPickerView: UIPickerView!
    @IBOutlet weak var helpPickerView: UIPickerView!
    @IBOutlet weak var creditsPickerView: UIPickerView!
    @IBOutlet weak var buyCreditsButton: UIButton!
    @IBOutlet weak var buyCreditsButtonYLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var creditsPickerYLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var helpPickerYLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var newsLine: UIButton!
    let model = UIDevice.currentDevice().model
    @IBAction func showHelpAction(sender: UIButton) {
        if helpPickerView.hidden {
            creditsPickerView.hidden = true
            newsLine.hidden = true
            buyCreditsButton.hidden = true
            helpPickerView.hidden = false
        } else {
            showBuyCreditsAction(sender)
        }
    }
    @IBAction func showBuyCreditsAction(sender: UIButton) {
        if creditsPickerView.hidden {
            helpPickerView.hidden = true
            creditsPickerView.hidden = false
            newsLine.hidden = false
            buyCreditsButton.hidden = false
            creditsPickerView.selectRow(0, inComponent: 0, animated: true)
            pickerView(creditsPickerView, didSelectRow: 0, inComponent: 0)
        }
    }
    //MARK: - UIPickerViewDataSource
    var pickerDataSourceHelp: [UIButton] { // a computed property instead of func
        get {
            return (0..<self.hints.count).map {
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.backdropImageView.bounds.width, height: 40))
                button.titleLabel!.font = UIFont(name: "ComicSansMS-Bold", size: 15)
                button.titleLabel!.lineBreakMode = .ByWordWrapping
                button.setTitle("(\($0 + 1)).   " + self.hints[$0], forState: .Normal)
                button.setTitleColor(UIColor.purpleColor(), forState: .Normal)
                return button
            }
        }
        set { self.pickerDataSourceHelp = newValue }
    }
    var pickerDataSourceCredits: [UIButton] { // a computed property instead of func
        get {
            return (0..<self.creditOptions.count).map {
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.backdropImageView.bounds.width, height: 40))
                button.setTitle(self.creditOptions[$0], forState: .Normal)
                button.setTitleColor(UIColor.blackColor(), forState: .Normal)
                return button
            }
        }
        set { self.pickerDataSourceCredits = newValue }
    }
    var backDropImages: [UIImage]?
    var backDrops: [String]?
    var ballImages: [UIImage]?
    var ballSkins: [String]?
    private var pickerDataSource: [UIImage] { // a computed property instead of func
        get { return ballImages! }
        set { self.pickerDataSource = newValue }
    }
    private var pickerDataSource1: [UIImage] { // a computed property instead of func
        get {
            return (0..<Settings().mySkins.count).map {
                UIImage(named: Settings().mySkins[$0])!
            }
        }
        set { self.pickerDataSource1 = newValue }
    }
    private var pickerDataSource2: [UIImage] { // a computed property instead of func
        get {
            return (0..<self.audios.count).map {
                UIImage(named: self.audios[$0])!
            }
        }
        set { self.pickerDataSource2 = newValue }
    }
    private var pickerDataSource3: [UIImage] { // a computed property instead of func
        get { return backDropImages! }
        set { self.pickerDataSource3 = newValue }
    }
    private var pickerDataSource4: [UIImage] { // a computed property instead of func
        get {
            return (0..<self.bonusTimes.count).map {
                UIImage(named: self.bonusTimes[$0])!
            }
        }
        set { self.pickerDataSource4 = newValue }
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1 { return 1 }
        if pickerView.tag == 2 { return 1 }
        return 5 } //number of wheels in the picker
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 { return pickerDataSourceHelp.count }
        if pickerView.tag == 2 { return pickerDataSourceCredits.count }
        if component == 0 {
            if doneLoad {
                return pickerDataSource.count
            } else { return 0 }
        }
        if component == 1 {
            return pickerDataSource1.count
        }
        if component == 2 {
            return pickerDataSource2.count
        }
        if component == 3 {
            if doneLoad {
                return pickerDataSource3.count
            }
        }
        return pickerDataSource4.count
    }
    //MARK: - UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if pickerView.tag > 0 {
            return 45.0
        }
        return 70.0
    }
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if pickerView.tag == 1 { return backdropImageView.bounds.width }
        if pickerView.tag == 2 { return backdropImageView.bounds.width }
        return backdropImageView.bounds.width / 5.25
    }
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView { //expensive
        if pickerView.tag == 1 { return pickerDataSourceHelp[row] }
        if pickerView.tag == 2 { return pickerDataSourceCredits[row] }
        var iv: UIImageView
        if component == 0 {
            iv = UIImageView(image: pickerDataSource[row])
            iv.bounds = CGRect(x: 0, y: 0, width: 65, height: 65)
            return iv
        }
        if component == 1 {
            iv = UIImageView(image: pickerDataSource1[row])
            iv.bounds = CGRect(x: 0, y: 0, width: 65, height: 65)
            return iv
        }
        if component == 2 {
            iv = UIImageView(image: pickerDataSource2[row])
            iv.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
            return iv
        }
        if component == 3 {
            iv = UIImageView(image: pickerDataSource3[row])
            iv.bounds = CGRect(x: 0, y: 0, width: 100, height: 75)
            return iv
        }
        if component == 4 {
            iv = UIImageView(image: pickerDataSource4[row])
            iv.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
            return iv
        }
        return UIView()
    }
    var selectedHintIndex = Settings().lastHint
    var selectedCreditIndex = 0
    var selectedBallSkin: UIImage?
    var selectedLogin: String?
    var selectedBallSkin1: UIImage?
    var selectedLogin1: String?
    var selectedAudio2: UIImage?
    var selectedLogin2: String?
    var selectedBackDrop3: UIImage?
    var selectedLogin3: String?
    var selectedBonusTime4: UIImage?
    var selectedLogin4: String?
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            selectedHintIndex = row
            return Settings().lastHint = selectedHintIndex
        }
        if pickerView.tag == 2 {
            return selectedCreditIndex = row
        }
        if component == 0 {
            selectedBallSkin = pickerDataSource[row]
            return selectedLogin = ballSkins![row]
        }
        if component == 1 {
            selectedBallSkin1 = pickerDataSource1[row]
            return selectedLogin1 = Settings().mySkins[row]
        }
        if component == 2 {
            selectedAudio2 = pickerDataSource2[row]
            return selectedLogin2 = audios[row]
        }
        if component == 3 {
            selectedBackDrop3 = pickerDataSource3[row]
            return selectedLogin3 = backDrops![row]
        }
        if component == 4 {
            selectedBonusTime4 = pickerDataSource4[row]
            selectedLogin4 = bonusTimes[row]
        }
    }
    private var availableCredits: Int { // a computed property instead of func
        get { return Settings().availableCredits }
        set { Settings().availableCredits = newValue }
    }
    let helper = IAPHelper()
    var url2: NSURL?
    @IBAction func demo2(sender: UIButton) {
        if url2 != nil {
            UIApplication.sharedApplication().openURL(url2!)
        }
    }
    var doneLoad = false
    //MARK: - view lifecycle
    override func viewDidLayoutSubviews() { //remove this if copied
        super.viewDidLayoutSubviews()
        if model.hasPrefix("iPad") {
            buyCreditsButtonYLayoutConstraint.constant = 10
            creditsPickerYLayoutConstraint.constant = -40
            helpPickerYLayoutConstraint.constant = -30
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        url2 = NSURL(string: DragItViewController.Constants.MarketingURL)!
        userPickerView.reloadComponent(0)
        userPickerView.delegate = self
        userPickerView.dataSource = self
        helpPickerView.delegate = self
        helpPickerView.dataSource = self
        creditsPickerView.delegate = self
        creditsPickerView.dataSource = self
        for aView in view.subviews {
            if let button = aView as? UIButton {
                if (0...9).contains(button.tag) {
                    button.layer.cornerRadius = 15.0
                    button.layer.borderWidth = 1.0
                    button.layer.borderColor = UIColor.blueColor().CGColor
                    button.superview!.bringSubviewToFront(button)
                }
            }
        }
    }
    func updateMySkins(withSkin: String) {
        if Settings().mySkins.count > 1 {
            if let index = ballSkins!.indexOf(withSkin) {
                self.selectedLogin1 = ballSkins![index]
                if let index1 = Settings().mySkins.indexOf((self.selectedLogin1!)) {
                    userPickerView.selectRow(index1, inComponent: 1, animated: true)
                    pickerView(userPickerView, didSelectRow: index1, inComponent: 1)
                }
            }
        } else {
            userPickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView(userPickerView, didSelectRow: 0, inComponent: 1)
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        userPickerView.selectRow(3, inComponent: 0, animated: true)
        pickerView(userPickerView, didSelectRow: 3, inComponent: 0)
        helpPickerView.selectRow(Settings().lastHint, inComponent: 0, animated: true)
        updateMySkins(Settings().purchasedUid!)
        userPickerView.selectRow(Settings().soundChoice, inComponent: 2, animated: true)
        pickerView(userPickerView, didSelectRow: Settings().soundChoice, inComponent: 2)
        var choice = Settings().backDropChoice
        userPickerView.selectRow(choice, inComponent: 3, animated: true)
        pickerView(userPickerView, didSelectRow: choice, inComponent: 3)
        showBuyCreditsAction(UIButton())
        choice = Settings().bonusTime - DragItViewController.Constants.BonusTime
        userPickerView.selectRow(choice, inComponent: 4, animated: true)
        pickerView(userPickerView, didSelectRow: choice, inComponent: 4)
    }
    func warnIfCreditsLow() {
        if availableCredits < 10 {
            alert("You have \(availableCredits) Credits!", message: "Play to earn at least 10 Credits or \n\n ...Buy Credits")        }
    }
    private func removePartialCurlTap() {
        if let gestures = self.view.gestureRecognizers {
            for gesture in gestures {
                if gesture.isKindOfClass(UITapGestureRecognizer) {
                    self.view.removeGestureRecognizer(gesture)
                }
            }
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        removePartialCurlTap()
        if helper.list.isEmpty && !helper.hasFailed {
            warnIfCreditsLow()
        }
        helper.setIAPs()
    }
    //MARK: - Action buySelection
    @IBAction func buySelection(sender: UIButton) {
        switch sender.tag {
        case 0: //print(sender.tag)
            checkout("Deduct 10 coins for selected Ball skin?", sender: sender)
        case 1: //print(sender.tag)
            if let login = self.selectedLogin1 { //can only happen if the wheel is spun
                let loggedInUser = User.login(login, password: "foo") //SWAP ball out to other owned ball
                print(loggedInUser)
                Settings().purchasedUid = loggedInUser.login  //new
            }
        case 2: //println(sender.tag)
            checkout("Deduct 10 coins for selected Audio?", sender: sender)
        case 3: //print(sender.tag)
            checkout("Deduct 10 coins for selected BackDrop image?", sender: sender)
        case 4: //print(sender.tag)
            let cost = minimumPWCredits()
            let msg = "Deduct " + String(cost) + " coins for selected bonus Time extension?"
            checkout(msg, sender: sender)
        case 5: //print(sender.tag)
            checkout("Add \(chosenNumberOfCredits()) game Credits?", sender: sender)
        default: break
        }
    }
    private var audioPlayer: AVAudioPlayer!
    private var path: String! = ""
    private var soundTrack = 0
    func prepareAudios() {
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
        audioPlayer.numberOfLoops = 0 //0 means play once
        audioPlayer.prepareToPlay()
    }
    func fireAutoStart(timer: NSTimer) {
        if audioPlayer?.playing == true {audioPlayer?.stop()}
    }
    func checkout(message: String, sender: UIButton) {
        let alertController = UIAlertController(title: "Checkout", message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Pay now!", style: UIAlertActionStyle.Default, handler: { (action) in
            self.buy(sender)  //this is the main use
        }))
        if sender.tag == 2 {
            for i in 0..<audios.count {
                if audios[i] == self.selectedLogin2! {
                    soundTrack = i
                    let autoStartTimer =  NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: "fireAutoStart:", userInfo: nil, repeats: false)
                    autoStartTimer
                }
            }
            alertController.addAction(UIAlertAction(title: "Sample 1st ...", style: UIAlertActionStyle.Cancel, handler: { (action) in
                self.audioPlayer?.pause()
                self.prepareAudios()
                if Settings().soundOn {
                    self.audioPlayer.play()
                } else {
                    self.audioPlayer?.pause()
                }
            }))
        } else {
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) in
            }))
        }
        presentViewController(alertController, animated: true, completion: nil)
    }
    func returnToDragIt() {
        if let divc = presentingViewController as? DragItViewController {
            divc.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    func buy(sender: UIButton) {
        switch sender.tag {
        case 0: //add selected ball skin to game
            if availableCredits > 9 {
                availableCredits -= 10
                let loggedInUser = User.login(self.selectedLogin!, password: "foo") //new ball
                print(loggedInUser)
                Settings().purchasedUid = loggedInUser.login  //new
                let results = Settings().mySkins.filter { el in el == self.selectedLogin! }
                if results.isEmpty {
                    Settings().mySkins.append(self.selectedLogin!)
                }
                userPickerView.reloadAllComponents()  //refresh pickerDataSource1
                updateMySkins(self.selectedLogin!)
                returnToDragIt()
            } else {
                warnIfCreditsLow()
            }
        case 1: print(sender.tag)
        case 2: //add selected sound track to game
            if availableCredits > 9 {
                availableCredits -= 10
                let loggedInUser = User.login(self.selectedLogin2!, password: "foo") //new audio
                print(loggedInUser)
                for i in 0..<audios.count {
                    if audios[i] == self.selectedLogin2! {
                        Settings().soundChoice = i
                        let results = Settings().myAudios.filter { el in el == self.selectedLogin2! }
                        if results.isEmpty {
                            Settings().myAudios.append(self.selectedLogin2!)
                        }
                    }
                }
                returnToDragIt()
            } else {
                warnIfCreditsLow()
            }
        case 3: //add selected backDrop
            if availableCredits > 9 {
                availableCredits -= 10
                let loggedInUser = User.login(self.selectedLogin2!, password: "foo") //new backDrop
                print(loggedInUser)
                for i in 0..<backDrops!.count {
                    if backDrops![i] == self.selectedLogin2! {
                        Settings().backDropChoice = i
                        Settings().mybackDrops.append(self.selectedLogin2!)
                    }
                }
                returnToDragIt()
            } else {
                warnIfCreditsLow()
            }
        case 4: //add selected bonusTime
            let minPWC = self.minimumPWCredits()
            if availableCredits >= minPWC {
                availableCredits -= minPWC
                let loggedInUser = User.login(self.selectedLogin4!, password: "foo") //new bonusTime
                print(loggedInUser)
                for i in 0..<bonusTimes.count {
                    if bonusTimes[i] == self.selectedLogin4! {
                        Settings().bonusTime = DragItViewController.Constants.BonusTime + i
                    }
                }
                returnToDragIt()
            } else {
                if availableCredits < minPWC {
                    alert("You have \(availableCredits) Credits!", message: "(you need \(self.minimumPWCredits()))...before buying extra bonus scoring seconds...")
                }
            }
        case 5: //add selected credits to game
            purchase()
        default: break
        }
    }
    func minimumPWCredits() -> Int {
        var minimumCredits = 10
        for i in 0..<bonusTimes.count {
            if bonusTimes[i] == self.selectedLogin4! {
                minimumCredits = i * 10
                return minimumCredits
            }
        }
        return 10
    }
    func alert(title: String, message: String) {
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    func chosenNumberOfCredits() -> Int {
        if self.selectedCreditIndex == 0 {
            pickerView(creditsPickerView, didSelectRow: 0, inComponent: 0)
        }
        var paidCredits = 10
        let credits = [10, 40, 70, 150, 350, 1000, 2500]
        for i in 0..<creditOptions.count {
            if i == self.selectedCreditIndex {
                paidCredits = credits[i]
            }
        }
        return paidCredits
    }
    func purchase() {
        var amount = 0.00
        if buyCreditsButton.hidden == false {
            let credits = chosenNumberOfCredits()
            let cost = [10: 0.99, 40: 2.99, 70: 4.99, 150: 9.99, 350: 19.99, 1000: 49.99, 2500: 99.99]
            amount = cost[credits]!
            print(amount)
            helper.pay4Credits(credits)
        }
    }
    let audios = [
        "audio77",
        "audio66",
        "audio90",
        "audio96",
        "audio125",
        "audio190",
        "audio209",
        "audio223",
        "audio3",
        "audio7",
        "audio78"
    ]
    let creditOptions = [
        "  $0.99  ⇢   10 Credits",
        "  $2.99  ⇢   40 Credits",
        "  $4.99  ⇢   70 Credits",
        "  $9.99  ⇢  150 Credits",
        " $19.99  ⇢  350 Credits",
        " $49.99  ⇢ 1000 Credits",
        " $99.99  ⇢ 2500 Credits"
    ]
    let hints = [
        "Drag RedBlock into GoalCircle, then circle ring changes!",
        "Start drag from top right corner for easier viewing",
        "After every 3rd Goal, you will go to Timed Bonus round!",
        "Tap [Demo] to view demo video on RedBlock website",
        "Tap [Back] to return",
        "Tap [SHOP] for BallSkins, BackDrops, audioTracks, +BonusTime",
        "Immediately Tap anywhere on screen in Bonus round!",
        "Hurry in Bonus round, it only lasts so long!",
        "Pan screen to attach/Drag-n-Drop a redBlock onto the Spoon",
        "Note: redBlock will attach/jump to your finger when u Pan",
        "...watch progress indicator for end of tap/drag/drop scoring",
        "After RedBlocks settle down...BONUS Credits are awarded!",
        "...progress indicator reverses, Bonus appears, times up!",
        "Use your accumulated Credits to [SHOP] and buy stuff!",
        "CREDITS cost $1 per 10 Credits...better deal if you buy more",
        "Personalized Audio tracks cost $0.99 or 10 Credits each",
        "Personalized BallSkins cost $0.99 or 10 Credits each",
        "Personalized backDrops cost $0.99 or 10 Credits each",
        "Buy extra BonusTime...adds seconds to live Bonus scoring!"
    ]
    let bonusTimes = [
        "u52b",
        "u66b",
        "u90b",
        "u96b",
        "u125b",
        "u190b"
    ]

}
