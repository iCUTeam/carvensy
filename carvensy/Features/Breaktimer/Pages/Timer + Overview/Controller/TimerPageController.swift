//
//  ViewController.swift
//  carvensy
//
//  Created by Kevin Gosalim on 14/06/22.
//

import UIKit
import UserNotifications

class TimerPageController: UIViewController {
    
    enum state : String
    {
        case notWorking = "notworking"
        case startWork = "startwork"
        case midWork = "midwork"
        case breakTime = "breaktime"
        case duringBreak = "duringbreak"
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var breakTimer: TimerProgressBar!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var endBtn: UIButton!

    
    //user defaults
    var startTime: Date?
    var currentState : state = .notWorking
    var choosenHour: Double = 3600
    var notifyTime: Double = 300
    
    let userdefaults = UserDefaults.standard
    let START_TIME = "starttime"
    let CURRENT_STATE = "currentstate"
    
    let layer = CATextLayer()
    
    var scheduledTimer: Timer!
    
    var doneWorking = false
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    var editBtn = UIBarButtonItem()
    
    var user: User?
    
    let userHelper = NewUser()
    
    let sessionHelper = SessionCRUD()
    
    override func viewWillAppear(_ animated: Bool) {
        
        userdefaults.synchronize()
        print(currentState)
        
        if currentState == .notWorking
        {
            breakTimer.progress = 0
            let time = secondsToHourMinutesSeconds(Int(choosenHour))
            layer.string = makeTimeString(hour: time.0, min: time.1, sec: time.2)
            startBtn.setTitle("Start Session", for: .normal)
            endBtn.isHidden = true
            editBtn.isEnabled = true
            
        }
        
        else if currentState == .midWork
        {
            editBtn.isEnabled = false
            startTimer()
            startBtn.setTitle("Jump to Break", for: .normal)
            endBtn.isHidden = false
            endBtn.setTitle("End Session", for: .normal)
            
        }
        
        else if currentState == .breakTime
        {
            
            if scheduledTimer != nil
            {
                scheduledTimer.invalidate()
            }
            
            titleLbl.text = "It's your break time!"
            titleLbl.textColor = CarvensyColor.redFont
            layer.string = makeTimeString(hour: 0, min: 0,sec: 0)
            startBtn.setTitle("Take a Break", for: .normal)
            
            if user?.break_plan?.snooze == true
            {
                endBtn.isHidden = false
                endBtn.setTitle("Snooze", for: .normal)
            }
            
            else
            {
                endBtn.isHidden = true
            }
           
        }
        
        else
        {
            let name = user?.name ?? "Dear user"
            editBtn.isEnabled = false
            breakTimer.progress = 1
            startTimer()
            setStartTime(date: Date())
            setSavedState(currState: .startWork)
            startBtn.setTitle("Jump to Break", for: .normal)
            endBtn.isHidden = false
            endBtn.setTitle("End Session", for: .normal)
            self.choosenHour = user?.break_plan?.break_every ?? 7200
            self.notifyTime = user?.break_plan?.notify_before ?? 300
            self.titleLbl.text = "Break in:"
            titleLbl.textColor = UIColor.black
            
            triggerNotification(notif_title: "\(name), it's time to rest your hand!", body: "Enjoy your break time with simple care for your hands. How about some stretches?", timeInterval: choosenHour)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editBtn = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPage))
        editBtn.tintColor = CarvensyColor.greenMain
        
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = editBtn
        title = "Break Timer"
        
        configureUserNotificationsCenter()
        userdefaults.synchronize()
        
        startTime = userdefaults.object(forKey: START_TIME) as? Date
        currentState = state(rawValue: userdefaults.string(forKey: CURRENT_STATE) ?? "notworking") ?? .notWorking
        breakTimer.useNormalText = true
        
        
        let width = breakTimer.frame.size.width
        let height = breakTimer.frame.size.height
        let fontsize : CGFloat
        
        print("width: \(width), height: \(height)")
        
        let alluser = userHelper.fetchUser()
        
        if alluser.count != 0
        {
            user = alluser.first
        }
       
        choosenHour = user?.break_plan?.break_every ?? 7200
        notifyTime = user?.break_plan?.notify_before ?? 300
        
        fontsize = min(width, height) / 6
        layer.backgroundColor = UIColor.clear.cgColor
        layer.foregroundColor = UIColor.systemGray.cgColor
        
        
        if currentState == .notWorking
        {
            breakTimer.progress = 0
            let time = secondsToHourMinutesSeconds(Int(choosenHour))
            layer.string = makeTimeString(hour: time.0, min: time.1, sec: time.2)
            startBtn.setTitle("Start Session", for: .normal)
            endBtn.isHidden = true
            editBtn.isEnabled = true
            
        }
        
        else if currentState == .startWork
        {
            breakTimer.progress = 1
            startTimer()
            setStartTime(date: Date())
            editBtn.isEnabled = false
            startBtn.setTitle("Jump to Break", for: .normal)
            endBtn.isHidden = false
            endBtn.setTitle("End Session", for: .normal)
        }
        
        else if currentState == .midWork
        {
            startTimer()
            editBtn.isEnabled = false
            startBtn.setTitle("Jump to Break", for: .normal)
            endBtn.isHidden = false
            endBtn.setTitle("End Session", for: .normal)
        }
        
        else if currentState == .breakTime
        {
            if scheduledTimer != nil
            {
                scheduledTimer.invalidate()
            }
            
            titleLbl.text = "It's your break time!"
            titleLbl.textColor = CarvensyColor.redFont
            editBtn.isEnabled = false
            layer.string = makeTimeString(hour: 0, min: 0,sec: 0)
            startBtn.setTitle("Take a Break", for: .normal)
            endBtn.isHidden = false
            endBtn.setTitle("Snooze", for: .normal)
            
            if user?.break_plan?.snooze == true
            {
                endBtn.isHidden = false
                endBtn.setTitle("Snooze", for: .normal)
            }
            
            else
            {
                endBtn.isHidden = true
            }
        }
        
        else
        {
            performSegue(withIdentifier: "goToBreakPage", sender: self)
        }
        
        layer.fontSize = fontsize
        layer.frame = CGRect(x: width - 205, y: height + 90, width: width, height: height)
        layer.alignmentMode = .center
        view.layer.addSublayer(layer)
        

    }
    
    
    @objc func refreshValue()
    {
        if let start = startTime
        {
            let diff = Date().timeIntervalSince(start)
            
            if choosenHour - diff <= 0
            {
                scheduledTimer.invalidate()
                layer.string = makeTimeString(hour: 0, min: 0, sec: 0)
                breakTimer.progress = 0
                titleLbl.textColor = CarvensyColor.redFont
                titleLbl.text = "It's your break time!"
                setSavedState(currState: .breakTime)
                startBtn.setTitle("Take a Break", for: .normal)
                endBtn.isHidden = false
                endBtn.setTitle("Snooze", for: .normal)
                
                if user?.break_plan?.snooze == true
                {
                    endBtn.isHidden = false
                    endBtn.setTitle("Snooze", for: .normal)
                }
                
                else
                {
                    endBtn.isHidden = true
                }
            }
            
            else
            {
                setSavedState(currState: .midWork)
                breakTimer.progress = min((choosenHour - diff) / choosenHour, 1)
                let time = secondsToHourMinutesSeconds(Int(choosenHour - diff))
                layer.string = makeTimeString(hour: time.0, min: time.1, sec: time.2)
                self.titleLbl.text = "Break in:"
                titleLbl.textColor = UIColor.black
            }
            
        }
        
        else
        {
            if scheduledTimer != nil
            {
                scheduledTimer.invalidate()
            }
            breakTimer.progress = 1
            let time = secondsToHourMinutesSeconds(Int(choosenHour))
            layer.string = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        }
    }
    
    
    func startTimer()
    {
        
        let time = secondsToHourMinutesSeconds(Int(choosenHour - 1))
        layer.string = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        scheduledTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
       
    }
    

    

    @objc private func editPage()
    {
        performSegue(withIdentifier: "goToEditPage", sender: self)
    }
    

    @IBAction func startAction(_ sender: UIButton) {
        
        let name = user?.name ?? "Dear user"
        triggerNotification(notif_title: "\(name), prepare to rest your hands", body: "\(String(format: "%.0f", notifyTime/60)) minute(s) left until your break time, prepare yourself to loosen up a bit", timeInterval: choosenHour - notifyTime)
        
        if currentState == .notWorking
        {
            
            let alert = UIAlertController(title: "Are you ready?", message: "Make sure your break setting has been adjusted to your needs before proceeding", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
                alert.dismiss(animated: true)
            }))
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self]_ in
                breakTimer.progress = 1
                setSavedState(currState: .startWork)
                startTimer()
                doneWorking = false
                setStartTime(date: Date())
                
                let name = user?.name ?? "Dear user"
                print(name)
                                                                
                triggerNotification(notif_title: "\(name), it's time to rest your hand!", body: "Enjoy your break time with simple care for your hands. How about some stretches?", timeInterval: choosenHour)
                
                editBtn.isEnabled = false
                sender.setTitle("Jump to Break", for: .normal)
                endBtn.isHidden = false
                endBtn.setTitle("End Session", for: .normal)
                
                //add new session
                
                sessionHelper.newSession(User: user!)
                
                
            }))
            
            self.present(alert, animated: true)
        }
        
        else if currentState == .midWork || currentState == .startWork
        {
            if scheduledTimer != nil
            {
                scheduledTimer.invalidate()
            }
            
            let alert = UIAlertController(title: "Are you sure?", message: "It’s not your scheduled break time yet. Please make sure you are comfortable to rest before you proceed.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
                alert.dismiss(animated: true)
                self.startTimer()
            }))
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self]_ in
                performSegue(withIdentifier: "goToBreakPage", sender: self)
                notificationCenter.removeAllPendingNotificationRequests()
                setSavedState(currState: .duringBreak)
                setStartTime(date: nil)

            }))
            
            self.present(alert, animated: true)
        }
        
        else if currentState == .breakTime
        {
            setSavedState(currState: .duringBreak)
            performSegue(withIdentifier: "goToBreakPage", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToBreakPage"
        {
            guard let vc = segue.destination as? BreakPageController else { return }
            vc.modalPresentationStyle = .fullScreen
        }
        
        else if segue.identifier == "goToEditPage"
        {
            guard let vc = segue.destination as? EditPageController else {return}
            vc.modalPresentationStyle = .fullScreen
            vc.breakPlan = user?.break_plan
        }
        
        else if segue.identifier == "goToDailySummary"
        {
            guard let vc = segue.destination as? DailySummaryController else {return}
            vc.dateStart = startTime
        }
    }
    
    @IBAction func endAction(_ sender: Any) {
        
        if currentState == .midWork || currentState == .startWork
        {
            let alert = UIAlertController(title: "Finished already?", message: "Make sure you have taken proper break before proceeding", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self]_ in
                setSavedState(currState: .notWorking)
                setStartTime(date: nil)
                userdefaults.synchronize()
                notificationCenter.removeAllPendingNotificationRequests()
                scheduledTimer.invalidate()
                performSegue(withIdentifier: "goToDailySummary", sender: self)
                doneWorking = true
                print(currentState)
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
                alert.dismiss(animated: true)
            }))
            
            self.present(alert, animated: true)
        }
        
        else if currentState == .breakTime
        {
            let alert = UIAlertController(title: "Select Snooze Duration", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "5 Minutes", style: .default, handler: { _ in
                
                let name = self.user?.name ?? "Dear user"
                self.choosenHour = 300
                self.breakTimer.progress = 1
                self.startTimer()
                self.setStartTime(date: Date())
                self.setSavedState(currState: .midWork)
                
                self.startBtn.setTitle("Jump to Break", for: .normal)
                self.endBtn.isHidden = false
                self.endBtn.setTitle("End Session", for: .normal)
                self.titleLbl.text = "Break in:"
                self.titleLbl.textColor = UIColor.black
                
                self.triggerNotification(notif_title: "\(name), it's time to rest your hand!", body: "Enjoy your break time with simple care for your hands. How about some stretches?", timeInterval: self.choosenHour)
            }))
            alert.addAction(UIAlertAction(title: "10 Minutes", style: .default, handler: { _ in
                let name = self.user?.name ?? "Dear user"
                self.choosenHour = 600
                self.breakTimer.progress = 1
                self.startTimer()
                self.setStartTime(date: Date())
                self.setSavedState(currState: .midWork)
                
                self.startBtn.setTitle("Jump to Break", for: .normal)
                self.endBtn.isHidden = false
                self.endBtn.setTitle("End Session", for: .normal)
                self.titleLbl.text = "Break in:"
                self.titleLbl.textColor = UIColor.black
                
                self.triggerNotification(notif_title: "\(name), it's time to rest your hand!", body: "Enjoy your break time with simple care for your hands. How about some stretches?", timeInterval: self.choosenHour)
            }))
            alert.addAction(UIAlertAction(title: "15 Minutes", style: .default, handler: { _ in
                let name = self.user?.name ?? "Dear user"
                self.choosenHour = 900
                self.breakTimer.progress = 1
                self.startTimer()
                self.setStartTime(date: Date())
                
                self.setSavedState(currState: .midWork)
                
                self.startBtn.setTitle("Jump to Break", for: .normal)
                self.endBtn.isHidden = false
                self.endBtn.setTitle("End Session", for: .normal)
                self.titleLbl.text = "Break in:"
                self.titleLbl.textColor = UIColor.black
                
                self.triggerNotification(notif_title: "\(name), it's time to rest your hand!", body: "Enjoy your break time with simple care for your hands. How about some stretches?", timeInterval: self.choosenHour)
            }))
            alert.addAction(UIAlertAction(title: "20 Minutes", style: .default, handler: { _ in
                let name = self.user?.name ?? "Dear user"
                self.choosenHour = 1200
                self.breakTimer.progress = 1
                self.startTimer()
                self.setStartTime(date: Date())
                
                self.setSavedState(currState: .midWork)
                
                self.startBtn.setTitle("Jump to Break", for: .normal)
                self.endBtn.isHidden = false
                self.endBtn.setTitle("End Session", for: .normal)
                self.titleLbl.text = "Break in:"
                self.titleLbl.textColor = UIColor.black
                
                self.triggerNotification(notif_title: "\(name), it's time to rest your hand!", body: "Enjoy your break time with simple care for your hands. How about some stretches?", timeInterval: self.choosenHour)
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    func setStartTime(date: Date?)
    {
        startTime = date
        userdefaults.set(startTime, forKey: START_TIME)
        
    }

    
    func setSavedState(currState: state)
    {
        currentState = currState
        userdefaults.set(currentState.rawValue, forKey: CURRENT_STATE)
    }
    
    private func triggerNotification(notif_title: String, body: String, timeInterval: Double)
  {
        notificationCenter.getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    self.scheduleNotification(notif_title: notif_title, body: body, timeInterval: timeInterval)
                })
            case .authorized:
                self.scheduleNotification(notif_title: notif_title, body: body, timeInterval: timeInterval)
            case .denied:
                print("The application not allowed to display notifications")
            case .provisional:
                print("The application authorized to post non-interruptive user notifications")
            case .ephemeral:
                print("The application is temporarily authorized to post notifications. Only available to app clips.")
            @unknown default:
                print("Application Not Allowed to Display Notifications")
            }
        }
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            completionHandler(success)
        }
    }
    
    private func scheduleNotification(notif_title: String, body: String, timeInterval: Double)
    {
        
            let content = UNMutableNotificationContent()
            content.title = notif_title
            content.body = body
            content.sound = UNNotificationSound.default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            let identifier = UUID().uuidString
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            notificationCenter.add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
    }
    
    private func configureUserNotificationsCenter() {
        notificationCenter.delegate = self
    
    }
}

extension TimerPageController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
}
