//
//  ViewController.swift
//  carvensy
//
//  Created by Kevin Gosalim on 14/06/22.
//

import UIKit
import UserNotifications

class TimerPageController: UIViewController {
    
    enum state
    {
        case startWork
        case midWork
        case breakTime
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var breakTimer: TimerProgressBar!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var endBtn: UIButton!

    
    //user defaults
    var timeCounting: Bool = false
    var startTime: Date?
    var stopTime: Date?
    
    var currentState : state = .startWork
    var choosenHour: Double = 3600
    
    let userdefaults = UserDefaults.standard
    let START_TIME = "starttime"
    let STOP_TIME = "stoptime"
    let COUTING_TIME = "countingtime"
    let CURRENT_STATE = "currentstate"
    
    let layer = CATextLayer()
    
    var scheduledTimer: Timer!
    
    override func viewWillAppear(_ animated: Bool) {
        checkState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        startTime = userdefaults.object(forKey: START_TIME) as? Date
        stopTime = userdefaults.object(forKey: STOP_TIME) as? Date
        currentState = userdefaults.object(forKey: CURRENT_STATE) as? state ?? .startWork
        timeCounting = userdefaults.bool(forKey: COUTING_TIME)
        
        checkState()
        breakTimer.useNormalText = true
        
        
        let width = breakTimer.frame.size.width
        let height = breakTimer.frame.size.height
        let fontsize : CGFloat
        let offset = min(width, height) * 0.1
        
        fontsize = min(width, height) / 4 - 5
        layer.backgroundColor = UIColor.clear.cgColor
        
        if currentState == .startWork
        {
            breakTimer.progress = 0
            let time = secondsToHourMinutesSeconds(Int(choosenHour))
            layer.string = makeTimeString(hour: time.0, min: time.1, sec: time.2)
            
        }
        
        else if currentState == .midWork
        {
            if timeCounting
            {
                startTimer()
            }
            
            else
            {
                stopTimer()
                
                if let start = startTime
                {
                    if let stop = stopTime
                    {
                        let time = calcRestartTime(start: start, stop: stop)
                        let diff = Date().timeIntervalSince(time)
                        let numb = secondsToHourMinutesSeconds(Int(choosenHour - diff))
                        layer.string = makeTimeString(hour: numb.0, min: numb.1, sec: numb.2)
                    }
                }
            }
        }
        
        else
        {
            
        }
        
        layer.fontSize = fontsize
        layer.frame = CGRect(x: 0, y: (height - fontsize - offset) / 2, width: width, height: height)
        layer.alignmentMode = .center
        view.layer.addSublayer(layer)
        
       
      
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPage))
    }
    
   private func calcRestartTime(start: Date, stop: Date) -> Date
    {
        let diff = start.timeIntervalSince(stop)
        return Date().addingTimeInterval(diff)
    }
    
    @objc func refreshValue()
    {
        if let start = startTime
        {
            let diff = Date().timeIntervalSince(start)
            
            if choosenHour - diff == 0
            {
                
            }
            
            let time = secondsToHourMinutesSeconds(Int(choosenHour - diff))
            layer.string = makeTimeString(hour: time.0, min: time.1, sec: time.2)
            
        }
        
        else
        {
            stopTimer()
            layer.string = makeTimeString(hour: 0, min: 0, sec: 0)
        }
    }
    
    
    func startTimer()
    {
        scheduledTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
        setTimeCounting(true)
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
    
    func stopTimer()
    {
        
        if scheduledTimer != nil
        {
            scheduledTimer.invalidate()
        }
   
        setTimeCounting(false)
    }
    

    @objc private func editPage()
    {
        //storyboard reference
    }
    
    private func checkState()
    {
        if currentState == .startWork
        {
            startBtn.setTitle("Start Session", for: .normal)
            endBtn.isHidden = true
        }
        
        else if currentState == .midWork
        {
            startBtn.setTitle("Jump to Break", for: .normal)
            endBtn.isHidden = false
            endBtn.setTitle("End Work", for: .normal)
        }
        
        else
        {
            startBtn.setTitle("Break", for: .normal)
            endBtn.setTitle("Snooze", for: .normal)
        }
    }
    

    @IBAction func startAction(_ sender: UIButton) {
        
        if currentState == .startWork
        {
            let alert = UIAlertController(title: "Are you ready?", message: "Make sure your break setting has been adjusted to your needs before proceeding", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self]_ in
                breakTimer.progress = 1
                setSavedState(currState: .midWork)
                sender.setTitle("Jump to Break", for: .normal)
                checkState()
                
                //ijin notifikasi
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.alert, .sound])
                { (granted, error) in
                    
                }
                
                //notif content
                let notif = UNMutableNotificationContent()
                notif.title = "Hello there!"
                notif.body = "I'm a notification, notice me!"
                
                //notif trigger
                let date = Date().addingTimeInterval(choosenHour)
                
                let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                
                //notif request
                let uuid = UUID().uuidString
                
                let request = UNNotificationRequest(identifier: uuid, content: notif, trigger: trigger)
                
                //register notif request
                
                center.add(request) { (error) in
                    
                }
                
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
                alert.dismiss(animated: true)
            }))
            
            self.present(alert, animated: true)
        }
        
        else if currentState == .midWork
        {
            //logic pause timer
            let alert = UIAlertController(title: "Are you sure?", message: "It’s not your scheduled break time yet. Please make sure you are comfortable to rest before you proceed.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self]_ in
              //storyboard reference
                setSavedState(currState: .startWork)

            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
                alert.dismiss(animated: true)
            }))
            
            self.present(alert, animated: true)
        }
        
        else
        {
            setSavedState(currState: .startWork)
            //storyboard reference
        }
    }
    @IBAction func endAction(_ sender: Any) {
        
        if currentState == .midWork
        {
            let alert = UIAlertController(title: "Finished already?", message: "Make sure you have taken proper break before proceeding", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self]_ in
                setSavedState(currState: .startWork)
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
                self.choosenHour += 300
                self.breakTimer.progress = 1
                //logic countdown sesuai durasi snooze
            }))
            alert.addAction(UIAlertAction(title: "10 Minutes", style: .default, handler: { _ in
                self.choosenHour += 600
                self.breakTimer.progress = 1
                //logic countdown sesuai durasi snooze
            }))
            alert.addAction(UIAlertAction(title: "15 Minutes", style: .default, handler: { _ in
                self.choosenHour += 900
                self.breakTimer.progress = 1
                //logic countdown sesuai durasi snooze
            }))
            alert.addAction(UIAlertAction(title: "20 Minutes", style: .default, handler: { _ in
                self.choosenHour += 1200
                self.breakTimer.progress = 1
                //logic countdown sesuai durasi snooze
            }))
        }
    }
    
    func setStartTime(date: Date?)
    {
        startTime = date
        userdefaults.set(startTime, forKey: START_TIME)
        
    }
    
    func setStopTime(date: Date?)
    {
        stopTime = date
        userdefaults.set(stopTime, forKey: STOP_TIME)
        
    }
    
    func setTimeCounting(_ val: Bool)
    {
        timeCounting = val
        userdefaults.set(timeCounting, forKey: COUTING_TIME)
    }
    
    func setSavedState(currState: state)
    {
        currentState = currState
        userdefaults.set(currentState, forKey: CURRENT_STATE)
    }
}

