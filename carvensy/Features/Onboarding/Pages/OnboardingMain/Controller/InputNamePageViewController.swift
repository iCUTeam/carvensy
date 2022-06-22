//
//  InputNamePageViewController.swift
//  carvensy
//
//  Created by Ariel Waraney on 21/06/22.
//

import UIKit

class InputNamePageViewController: UIViewController {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var nameCardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameCardView.roundViewCorner([.topLeft,.topRight,.bottomLeft,.bottomRight], radius: 10)
        
        //hide the selector when tap outside
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideSelector)))
        //dismiss keyboard when return key pressed
        userName.delegate = self
        
        //keyboard appearance
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func hideSelector(){
        self.view.endEditing(true)
    }
    
    @objc private func keyboardShow(notification: NSNotification){
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentFirst() as? UITextField else { return }
        
        //check if the top of the keybaord is above the bottom of the current focused textbox
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height
        
        //make sure the swipe only once above the default position
        if view.frame.origin.y >= 0 {
            //check if text field bottom is below keybaord bottom - bump the frame up
            if textFieldBottomY > keyboardTopY {
                let textBoxY = convertedTextFieldFrame.origin.y
                let newFrameY = ((textBoxY - keyboardTopY / 2) * -1) + 50
                view.frame.origin.y = newFrameY
            }
        }
    }
    
    @objc private func keyboardHide(){
        self.view.frame.origin.y = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //TODO: Push view upper for text field visibility when keyboard toggled on.
}

extension UIResponder {
    
    private struct Static {
        static weak var responder: UIResponder?
    }
    
    //find the current first responder and return the current Responder if exsist
    
    static func currentFirst()-> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }
    
    @objc private func _trap(){
        //the element selected
        Static.responder = self
    }
}
