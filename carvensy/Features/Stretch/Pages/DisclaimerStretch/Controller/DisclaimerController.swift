//
//  DisclaimerController.swift
//  carvensy
//
//  Created by Ariel Waraney on 19/06/22.
//

import UIKit

class DisclaimerController: UIViewController {
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var secondaryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func primaryButtonPressed(_ sender: Any) {
        //TODO: I Understand Button Action
        print("I Understand")
    }
    
    @IBAction func secondaryButtonPressed(_ sender: Any) {
        //TODO: No Thanks Button Action
        print("No Thanks")
    }
}
