//
//  ConciergeViewController.swift
//  carvensy
//
//  Created by Kevin Gosalim on 26/06/22.
//

import UIKit

class ConciergeViewController: UIViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if LandscapeManager.shared.isFirstLaunch {
            performSegue(withIdentifier: "toOnboardingMain", sender: nil)
            LandscapeManager.shared.isFirstLaunch = true
        } else {
            performSegue(withIdentifier: "toTimerPage", sender: nil)
        }
    }
}
