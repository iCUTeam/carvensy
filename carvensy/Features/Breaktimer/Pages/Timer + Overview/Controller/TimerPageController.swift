//
//  ViewController.swift
//  carvensy
//
//  Created by Kevin Gosalim on 14/06/22.
//

import UIKit

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
    
    var currentState : state = .startWork
    var choosenHour: Double = 3600
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkState()
        breakTimer.isHour = true
        breakTimer.selectedTime = choosenHour
        breakTimer.progress = 0
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPage))
    }
    
    //perlu add logic background timer dan countdown timernya

    @objc private func editPage()
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "edit-page") as! EditPageController
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true)
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
    

    @IBAction func startAction(_ sender: Any) {
        
        if currentState == .startWork
        {
            let alert = UIAlertController(title: "Are you ready?", message: "Make sure your break setting has been adjusted to your needs before proceeding", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self]_ in
                breakTimer.progress = 1
                currentState = .midWork
                checkState()
                //logic save state
                //logic start timer
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
                alert.dismiss(animated: true)
            }))
            
            self.present(alert, animated: true)
        }
        
        else if currentState == .midWork
        {
            let alert = UIAlertController(title: "Are you sure?", message: "It’s not your scheduled break time yet. Please make sure you are comfortable to rest before you proceed.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self]_ in
                
                //logic pause timer
                let vc = storyboard?.instantiateViewController(withIdentifier: "break-page") as! BreakPageController
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
                alert.dismiss(animated: true)
            }))
            
            self.present(alert, animated: true)
        }
        
        else
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "break-page") as! BreakPageController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
            //logic save state -> balik ke startwork
        }
    }
    @IBAction func endAction(_ sender: Any) {
        
        if currentState == .midWork
        {
            let alert = UIAlertController(title: "Finished already?", message: "Make sure you have taken proper break before proceeding", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self]_ in
                
                //logic cek stretch and break
                let vc = storyboard?.instantiateViewController(withIdentifier: "end-page") as! StretchFinishPageController
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
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
}

