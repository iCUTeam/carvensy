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
        let alert = UIAlertController(title: "Are you sure?", message: "Make sure your hands are fully rested and ready for another round of work before proceeding", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.performSegue(withIdentifier: "goBackToWork", sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChooseStretch"
        {
            guard let vc = segue.destination as? ChooseStretchController else { return }
            vc.modalPresentationStyle = .fullScreen
        }
        
        else if segue.identifier == "goBackToWork"
        {
            guard let vc = segue.destination as? TimerPageController else { return }
            vc.modalPresentationStyle = .fullScreen
            vc.currentState = .midWork
        }
    }
}
