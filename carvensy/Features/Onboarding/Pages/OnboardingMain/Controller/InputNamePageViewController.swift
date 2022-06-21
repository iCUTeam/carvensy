//
//  InputNamePageViewController.swift
//  carvensy
//
//  Created by Ariel Waraney on 21/06/22.
//

import UIKit

class InputNamePageViewController: UIViewController {
    @IBOutlet weak var userName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //hide the selector when tap outside
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideSelector)))
        //dismiss keyboard when return key pressed
        userName.delegate = self
    }

    @objc private func hideSelector(){
        self.view.endEditing(true)
    }
    
    //TODO: Push view upper for text field visibility when keyboard toggled on.
}
