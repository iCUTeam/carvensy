//
//  CompleteAndShowPlanPageViewController.swift
//  carvensy
//
//  Created by Ariel Waraney on 23/06/22.
//

import UIKit

class CompleteAndShowPlanPageViewController: UIViewController {
    
    @IBOutlet weak var userNameView: UILabel!
    @IBOutlet weak var intervalTime: UILabel!
    @IBOutlet weak var notifyTime: UILabel!
    @IBOutlet weak var snoozeStatus: UILabel!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var whiteView: UIView!
    
    private var userName: String = ""
    var breakDuration: Double?
    var notifyDuration: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //user default
        if let value = UserDefaultManager.shared.defaults.value(forKey: "userName") as? String {
            userNameView.text = "\(value), you are in good hands!"
            userName = value
        }
        
        let breakTimeInDouble = breakDuration ?? 0
        let notifyTimeInDouble = notifyDuration ?? 0
        
        let breakText = timeStringInHour(time: Int(breakTimeInDouble))
        let notifyText = timeStringInHour(time: Int(notifyTimeInDouble))
        
        if breakDuration != nil {
            intervalTime.text = breakText
        }
        if notifyDuration != nil {
            notifyTime.text = notifyText
        }
        
        whiteView.roundViewCorner([.bottomRight,.bottomLeft,.topRight,.topLeft], radius: 10)
    }
    
    @IBAction func getStartedPressed(_ sender: Any) {
        //TODO: save to core data
        let breakTimeInDouble = breakDuration ?? 0
        let notifyTimeInDouble = notifyDuration ?? 0
        print("username : \(userName)")
        print("break time every : \(breakTimeInDouble)")
        print("notify in : \(notifyTimeInDouble)")
        
        let newUserHelper = NewUser()
        newUserHelper.newUser(name: userName, break_every: breakTimeInDouble, notify: notifyTimeInDouble, snooze: true)
        
        //redirect to timer page
        self.performSegue(withIdentifier: "newUserGoToBreakTimerPage", sender: self)
        
        //flag user done with onboarding process
        OnboardManager.shared.isDoneOnboarding = true
    }
    
    @IBAction func startOverPressed(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        //TODO: redirect back to introduction ??
    }
    
}
