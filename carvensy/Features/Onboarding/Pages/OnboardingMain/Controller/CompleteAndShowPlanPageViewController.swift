//
//  CompleteAndShowPlanPageViewController.swift
//  carvensy
//
//  Created by Ariel Waraney on 23/06/22.
//

import UIKit

class CompleteAndShowPlanPageViewController: UIViewController {
    
    @IBOutlet weak var intervalTime: UILabel!
    @IBOutlet weak var notifyTime: UILabel!
    @IBOutlet weak var snoozeStatus: UILabel!
    
    private var indexCardChoosen: Int?
    private var userName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func getStartedPressed(_ sender: Any) {
        //TODO: save to core data
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startOverPressed(_ sender: Any) {
        //TODO: redirect back to introduction
        dismiss(animated: true, completion: nil)
    }
    
}
