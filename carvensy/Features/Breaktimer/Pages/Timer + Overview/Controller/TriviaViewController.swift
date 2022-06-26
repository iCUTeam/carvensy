//
//  TriviaViewController.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 22/06/22.
//

import UIKit

class TriviaViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var viewSymptom: UIView!
    @IBOutlet weak var viewAbout: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "About CTS"
        self.viewSymptom.alpha = 0
        self.viewAbout.alpha = 1
    }
    
    @IBAction func changeSegment(_ sender: UISegmentedControl)
    {
        //more about CTS
        if sender.selectedSegmentIndex == 0
        {
            //show info (more about CTS)
            self.viewSymptom.alpha = 0
            self.viewAbout.alpha = 1
        }
        
        else
        {
            //show info (CTS symptom)
            self.viewSymptom.alpha = 1
            self.viewAbout.alpha = 0
        }
    }

}
