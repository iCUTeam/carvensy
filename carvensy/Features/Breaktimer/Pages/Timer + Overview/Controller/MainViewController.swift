//
//  MainViewController.swift
//  carvensy
//
//  Created by Kevin Gosalim on 26/06/22.
//

import UIKit

 class MainViewController: UIViewController {

     // MARK: - Life Cycle
     override func viewDidLoad() {
         super.viewDidLoad()
     }

     override func viewDidAppear(_ animated: Bool) {
         if OnboardManager.shared.isDoneOnboarding {
             performSegue(withIdentifier: "toOnboardingMain", sender: nil)
         } else {
             performSegue(withIdentifier: "toTimerPage", sender: nil)
         }
     }
 }
