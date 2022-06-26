//
//  PostWorkController.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 21/06/22.
//

import UIKit

class PostWorkController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func endWork(_ sender: Any)
    {
        performSegue(withIdentifier: "goToStartTimer", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToStartTimer"
        {
            guard let vc = segue.destination as? TimerPageController else { return }
            vc.modalPresentationStyle = .fullScreen
            vc.currentState = .notWorking
        }
    }

   
}
