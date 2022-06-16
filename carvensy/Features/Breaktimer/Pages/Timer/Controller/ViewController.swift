//
//  ViewController.swift
//  carvensy
//
//  Created by Kevin Gosalim on 14/06/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerLabel.textColor = CarvensyColor.greenMain
    }


}

