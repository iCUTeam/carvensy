//
//  PainAssessmentPageViewController.swift
//  carvensy
//
//  Created by Ariel Waraney on 21/06/22.
//

import UIKit

class PainAssessmentPageViewController: UIViewController {
    
    @IBOutlet weak var symptomButton: UIButton!

    @IBOutlet weak var tapAreaFirst: UIControl!
    @IBOutlet weak var tapAreaSecond: UIControl!
    @IBOutlet weak var tapAreaThird: UIControl!
    
    @IBOutlet weak var firstCard: UIView!
    @IBOutlet weak var secondCard: UIView!
    @IBOutlet weak var thirdCard: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        firstCard.roundViewCorner([.bottomRight,.bottomLeft,.topRight,.topLeft], radius: 10)
        secondCard.roundViewCorner([.bottomRight,.bottomLeft,.topRight,.topLeft], radius: 10)
        thirdCard.roundViewCorner([.bottomRight,.bottomLeft,.topRight,.topLeft], radius: 10)
    }
    
    @IBAction func symptomButtonPressed(_ sender: Any) {
        //TODO: CTS Common Symptoms Modal View
        print("cts more")
    }
    
    @IBAction func moderateCardAreaPressed(_ sender: Any) {
        print("moderate masuk")
        //TODO: Alert Choose Confirmation
    }
    
    @IBAction func mildCardAreaPressed(_ sender: Any) {
        print("mild masuk")
        //TODO: Alert Choose Confirmation
    }
    
    @IBAction func noSymptomCardAreaPressed(_ sender: Any) {
        print("no symptom masuk")
        //TODO: Working Assessment Modal View
    }
    
}
