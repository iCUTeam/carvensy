//
//  BreakPageController.swift
//  carvensy
//
//  Created by Ariel Waraney on 16/06/22.
//

import UIKit

class BreakPageController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var stretchButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    var session: Session?
    
    var sessionHelper = SessionCRUD()
    
    var count: Double = 0
    
    var scheduleTimer : Timer!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Break"
        navigationItem.largeTitleDisplayMode = .always
        
        if scheduleTimer == nil
        {
            scheduleTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addCount), userInfo: nil, repeats: true)
        }
        
        stretchButton.tintColor = CarvensyColor.greenMain
        finishButton.tintColor = CarvensyColor.greenMain
    }
    
    @objc func addCount()
    {
        count += 1
    }
    
    @IBAction func stretchButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "goToChooseStretch", sender: self)
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "Make sure your hands are fully rested and ready for another round of work before proceeding", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
          
            
            let allSession = self.sessionHelper.fetchSession()
            
            if allSession.count != 0
            {
                self.session = allSession.first
            }
            
            if self.session?.break_relation == nil
            {
                self.sessionHelper.firstBreak(Current_session: self.session!, duration: self.count)
            }
            
            else
            {
                self.sessionHelper.addBreak(Current_Session: self.session!, duration: self.count)
            }
            
            self.scheduleTimer.invalidate()
            self.count = 0
            
            self.dismiss(animated: true)
        }))
        
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChooseStretch"
        {
            guard let vc = segue.destination as? ChooseStretchController else { return }
            vc.modalPresentationStyle = .fullScreen
        }
        
        else if segue.identifier == "goBackToWork"
        {
            guard let vc = segue.destination as? TimerPageController else { return }
            vc.modalPresentationStyle = .fullScreen
            vc.currentState = .startWork
        }
    }
    
    @IBAction func unwind(_ seg: UIStoryboardSegue)
    {
        
    }
}
