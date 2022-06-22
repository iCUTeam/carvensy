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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Break"
        
        //TODO: Start Break Time Duration Counter Here
        
    }
    
    @IBAction func stretchButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToChooseStretch", sender: self)
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        //TODO: Add Alert Confirmation
        //TODO: Add Action
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChooseStretch"
        {
            guard let vc = segue.destination as? ChooseStretchController else { return }
            vc.modalPresentationStyle = .fullScreen
        }
    }
}
