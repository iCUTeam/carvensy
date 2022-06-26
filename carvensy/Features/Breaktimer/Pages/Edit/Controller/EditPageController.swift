//
//  EditPageController.swift
//  carvensy
//
//  Created by Ariel Waraney on 15/06/22.
//

import UIKit

class EditPageController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var breakEveryTextField: UITextField!
    @IBOutlet weak var notifyBeforeTextField: UITextField!
    @IBOutlet weak var snoozeSwitch: UISwitch!
    
    var breakPicker = UIPickerView()
    var notifierPicker = UIPickerView()
    
    let breakOptions: [Double]  = [900, 1800, 3600, 7200, 10800]
    let notifyOptions: [Double] = [60 , 180, 300, 600, 900]
    
    var breakOpt = 0
    var notifOpt = 0
    
    var breakPlanHelper = BreakPlanRU()
    
    var breakPlan: Break_Plan?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveChange))
        setUpData()
        // set up picker
        breakEveryTextField.inputView = breakPicker
        breakPicker.delegate = self
        breakPicker.dataSource = self
        notifyBeforeTextField.inputView = notifierPicker
        notifierPicker.dataSource = self
        notifierPicker.delegate = self
        
        // tag picker
        breakPicker.tag = 1
        notifierPicker.tag = 2
        
        //hide the selector when tap outside
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideSelector)))
        //dismiss keyboard when return key pressed
        nameTextField.delegate = self
        
       
    }
    
    @objc private func saveChange()
    {
        breakPlanHelper.editBreakPlan(BreakPlan: breakPlan!, break_every: breakOptions[breakOpt], notify: notifyOptions[notifOpt], snooze: snoozeSwitch.isOn, name: nameTextField.text ?? "")
    }
    
    private func setUpData()
    {
        let allBreakPlan = breakPlanHelper.fetchBreakPlan()
        breakPlan = breakPlanHelper.currentBreakPlan(break_plans: allBreakPlan)
        
        nameTextField.text = breakPlan?.user?.name
        
        
        for x in 0..<breakOptions.count
        {
            if breakOptions[x] == breakPlan?.break_every
            {
                breakOpt = x
            }
            
            if notifyOptions[x] == breakPlan?.notify_before
            {
                notifOpt = x
            }
        }
        
        breakPicker.selectRow(breakOpt, inComponent: 0, animated: false)
        notifierPicker.selectRow(notifOpt, inComponent: 0, animated: false)
        snoozeSwitch.isOn = breakPlan?.snooze ?? false
        
    }
    
    @objc private func hideSelector(){
        self.view.endEditing(true)
    }
}

extension EditPageController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return breakOptions.count
        case 2:
            return notifyOptions.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        switch pickerView.tag {
        case 1:
            return timeStringInHour(time: Int(breakOptions[row]))
        case 2:
            return timeStringInHour(time: Int(notifyOptions[row]))
        default:
            return "Data Not Found!"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            breakOpt = row
            breakEveryTextField.text = timeStringInHour(time: Int(breakOptions[row]))
            breakEveryTextField.resignFirstResponder()
        case 2:
            notifOpt = row
            notifyBeforeTextField.text = timeStringInHour(time: Int(notifyOptions[row]))
            notifyBeforeTextField.resignFirstResponder()
        default:
           return
        }
    }
}

//MARK: Move To Extension For Reusable
extension UIViewController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
