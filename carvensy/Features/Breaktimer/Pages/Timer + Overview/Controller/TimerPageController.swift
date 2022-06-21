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
        case startWork = "startwork"
        case midWork = "midwork"
        case breakTime = "breaktime"
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var breakTimer: TimerProgressBar!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var endBtn: UIButton!

    
    //user defaults
    var startTime: Date?
    var currentState : state = .startWork
    var choosenHour: Double = 60
    
    let userdefaults = UserDefaults.standard
    let START_TIME = "starttime"
    let CURRENT_STATE = "currentstate"
    
    let layer = CATextLayer()
    
    var scheduledTimer: Timer!
    
    let center = UNUserNotificationCenter.current()
    
    
    override func viewWillAppear(_ animated: Bool) {
        if currentState == .startWork
        {
            breakTimer.progress = 0
            let time = secondsToHourMinutesSeconds(Int(choosenHour))
            layer.string = makeTimeString(hour: time.0, min: time.1, sec: time.2)
            startBtn.setTitle("Start Work", for: .normal)
            endBtn.isHidden = true
            
        }
        
        else if currentState == .midWork
        {
            startTimer()
            startBtn.setTitle("Jump to Break", for: .normal)
            endBtn.isHidden = false
            endBtn.setTitle("End Work", for: .normal)
        }
        
        else
        {
            if scheduledTimer != nil
            {
                scheduledTimer.invalidate()
            }
            
            layer.string = makeTimeString(hour: 0, min: 0,sec: 0)
            startBtn.setTitle("Break", for: .normal)
            endBtn.isHidden = false
            endBtn.setTitle("Snooze", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        startTime = userdefaults.object(forKey: START_TIME) as? Date
        currentState = state(rawValue: userdefaults.string(forKey: CURRENT_STATE) ?? "startwork") ?? .startWork
        breakTimer.useNormalText = true
        
        
        let width = breakTimer.frame.size.width
        let height = breakTimer.frame.size.height
        let fontsize : CGFloat
        let offset = min(width, height) * 0.1
        
        fontsize = min(width, height) / 6
        layer.backgroundColor = UIColor.clear.cgColor
        layer.foregroundColor = UIColor.systemGray.cgColor
        
        if currentState == .startWork
        {
            breakTimer.progress = 0
            let time = secondsToHourMinutesSeconds(Int(choosenHour))
            layer.string = makeTimeString(hour: time.0, min: time.1, sec: time.2)
            startBtn.setTitle("Start Work", for: .normal)
            endBtn.isHidden = true
            
        }
        
        else if currentState == .midWork
        {
            startTimer()
            startBtn.setTitle("Jump to Break", for: .normal)
            endBtn.isHidden = false
            endBtn.setTitle("End Work", for: .normal)
        }
        
        else
        {
            if scheduledTimer != nil
            {
                scheduledTimer.invalidate()
            }
            
            layer.string = makeTimeString(hour: 0, min: 0,sec: 0)
            startBtn.setTitle("Break", for: .normal)
            endBtn.isHidden = false
            endBtn.setTitle("Snooze", for: .normal)
        }
        
        layer.fontSize = fontsize
        layer.frame = CGRect(x: width - 225, y: height + 100, width: width, height: height)
        layer.alignmentMode = .center
        view.layer.addSublayer(layer)
        
       
      
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPage))
        title = "Break Timer"
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
                setSavedState(currState: .breakTime)
                startBtn.setTitle("Break", for: .normal)
                endBtn.isHidden = false
                endBtn.setTitle("Snooze", for: .normal)
            }
            
            else
            {
                breakTimer.progress = min((choosenHour - diff) / choosenHour, 1)
                let time = secondsToHourMinutesSeconds(Int(choosenHour - diff))
                layer.string = makeTimeString(hour: time.0, min: time.1, sec: time.2)
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
        scheduledTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
    }
    
    
    func secondsToHourMinutesSeconds(_ ms: Int) -> (Int, Int, Int)
    {
        let hour = ms/3600
        let min = (ms % 3600) / 60
        let sec = (ms % 3600) % 60
        
        return (hour, min, sec)
    }
    
    func makeTimeString(hour: Int, min: Int, sec: Int) -> String
    {
        var timeString = ""
        timeString += String(format: "%02d", hour)
        timeString += ":"
        timeString += String(format: "%02d", min)
        timeString += ":"
        timeString += String(format: "%02d", sec)
        return timeString
    }
    

    @objc private func editPage()
    {
        performSegue(withIdentifier: "goToEditPage", sender: self)
    }
    

    @IBAction func startAction(_ sender: UIButton) {
        
        if currentState == .startWork
        {
            //ijin notifikasi
            center.requestAuthorization(options: [.alert, .sound])
            { (granted, error) in
                
            }
            //notif content
            let notif = UNMutableNotificationContent()
            notif.title = "User, prepare to rest your hand!"
            notif.body = "5 minutes left until your break time, prepare yourself to loosen up a bit"
            
            //notif trigger
            let date = Date().addingTimeInterval(5)
            
            let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
            
            //notif request
            let uuid = UUID().uuidString
            
            let request = UNNotificationRequest(identifier: uuid, content: notif, trigger: trigger)
            
            //register notif request
            
            center.add(request) { (error) in
                
            }
            
            let notif2 = UNMutableNotificationContent()
            notif2.title = "User, it's time to rest your hand!"
            notif2.body = "Enjoy your break time with simple care for your hands. How about some stretches?"

            let date2 = Date().addingTimeInterval(10)

            let dateComp2 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date2)

            let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateComp2, repeats: false)

            let uuid2 = UUID().uuidString

            let request2 = UNNotificationRequest(identifier: uuid2, content: notif2, trigger: trigger2)

            center.add(request2)
            { (error) in

            }
            
            let alert = UIAlertController(title: "Are you ready?", message: "Make sure your break setting has been adjusted to your needs before proceeding", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self]_ in
                breakTimer.progress = 1
                setSavedState(currState: .midWork)
                startTimer()
                setStartTime(date: Date())
                
                sender.setTitle("Jump to Break", for: .normal)
                endBtn.isHidden = false
                endBtn.setTitle("End Work", for: .normal)
                
                
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
                alert.dismiss(animated: true)
            }))
            
            self.present(alert, animated: true)
        }
        
        else if currentState == .midWork
        {
            if scheduledTimer != nil
            {
                scheduledTimer.invalidate()
            }
            
            let alert = UIAlertController(title: "Are you sure?", message: "It’s not your scheduled break time yet. Please make sure you are comfortable to rest before you proceed.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self]_ in
                performSegue(withIdentifier: "goToBreakPage", sender: self)
                center.removeAllPendingNotificationRequests()
                setSavedState(currState: .startWork)
                setStartTime(date: nil)

            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
                alert.dismiss(animated: true)
                self.startTimer()
            }))
            
            self.present(alert, animated: true)
        }
        
        else
        {
            setSavedState(currState: .startWork)
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
        }
    }
    @IBAction func endAction(_ sender: Any) {
        
        if currentState == .midWork
        {
            let alert = UIAlertController(title: "Finished already?", message: "Make sure you have taken proper break before proceeding", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self]_ in
                setSavedState(currState: .startWork)
                
                center.removeAllPendingNotificationRequests()
                //logic cek stretch and break
               //storyboard reference
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
                self.choosenHour = 300
                self.breakTimer.progress = 1
                self.startTimer()
                self.setStartTime(date: Date())
            }))
            alert.addAction(UIAlertAction(title: "10 Minutes", style: .default, handler: { _ in
                self.choosenHour = 600
                self.breakTimer.progress = 1
                self.startTimer()
                self.setStartTime(date: Date())
            }))
            alert.addAction(UIAlertAction(title: "15 Minutes", style: .default, handler: { _ in
                self.choosenHour = 900
                self.breakTimer.progress = 1
                self.startTimer()
                self.setStartTime(date: Date())
            }))
            alert.addAction(UIAlertAction(title: "20 Minutes", style: .default, handler: { _ in
                self.choosenHour = 1200
                self.breakTimer.progress = 1
                self.startTimer()
                self.setStartTime(date: Date())
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
}

