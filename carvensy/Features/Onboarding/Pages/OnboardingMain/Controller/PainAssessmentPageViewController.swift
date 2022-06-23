//
//  PainAssessmentPageViewController.swift
//  carvensy
//
//  Created by Ariel Waraney on 21/06/22.
//

import UIKit

class PainAssessmentPageViewController: UIViewController {
    
    @IBOutlet weak var tapAreaFirst: UIControl!
    @IBOutlet weak var tapAreaSecond: UIControl!
    @IBOutlet weak var tapAreaThird: UIControl!
    
    @IBOutlet weak var firstCard: UIView!
    @IBOutlet weak var secondCard: UIView!
    @IBOutlet weak var thirdCard: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpCardCornerRadius()
        setUpCardShadow()
    }
    
    @IBAction func moderateCardAreaPressed(_ sender: Any) {
        //card index number = 1 (Moderate)
        showAlert(cardIndexNumber: 1)
    }
    
    @IBAction func mildCardAreaPressed(_ sender: Any) {
        //card index number = 2 (Mild)
        showAlert(cardIndexNumber: 2)
    }
    
    @IBAction func noSymptomCardAreaPressed(_ sender: Any) {
        //Assessment Modal View
        self.performSegue(withIdentifier: "showWorkingAssessModal", sender: self)
    }
    
    private func setUpCardCornerRadius(){
        firstCard.roundViewCorner([.bottomRight,.bottomLeft,.topRight,.topLeft], radius: 10)
        secondCard.roundViewCorner([.bottomRight,.bottomLeft,.topRight,.topLeft], radius: 10)
        thirdCard.roundViewCorner([.bottomRight,.bottomLeft,.topRight,.topLeft], radius: 10)
    }
    
    private func setUpCardShadow(){
        //black shadow color
        firstCard.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        firstCard.layer.shadowOpacity = 0.3
        firstCard.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        secondCard.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        secondCard.layer.shadowOpacity = 0.3
        secondCard.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        thirdCard.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        thirdCard.layer.shadowOpacity = 0.3
        thirdCard.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    private func showAlert(cardIndexNumber: Int) {
        //show alert confirmation
        let confirmationAlert = UIAlertController(title: "Everything is correct?", message: "Based on your answers we will recommend you with the most suitable break time settings", preferredStyle: .alert)
        confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            //TODO: send action code based on index
            /*
                1. Moderate Card
                2. Mild Card
                3. No Symptom - Hectic Work
                4. No Symptom - Busy Work
                5. No Symptom - Normal Work
             */
            print("card choose: \(cardIndexNumber)")
            
            self.performSegue(withIdentifier: "goShowPlanSettings", sender: self)
        }))
        
        confirmationAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(confirmationAlert, animated: true, completion: nil)
    }
}
