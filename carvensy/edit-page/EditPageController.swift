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
    
    //MARK: move to model?
    let breakOptions = ["15 mins", "30 mins", "1 hour", "2 hours", "3 hours"]
    let notifyOptions = ["1 min", "3 mins", "5 mins", "10 mins", "15 mins"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Display all data that has been saved from core data
        nameTextField.text = ""
        
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
            return breakOptions[row]
        case 2:
            return notifyOptions[row]
        default:
            return "Data Not Found!"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            breakEveryTextField.text = breakOptions[row]
            breakEveryTextField.resignFirstResponder()
        case 2:
            notifyBeforeTextField.text = notifyOptions[row]
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
