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
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func primaryButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToSteps", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSteps"
        {
            guard let vc = segue.destination as? StretchStepController else { return }
            vc.modalPresentationStyle = .fullScreen
            vc.stretchChoice = index
        }
    }
}
