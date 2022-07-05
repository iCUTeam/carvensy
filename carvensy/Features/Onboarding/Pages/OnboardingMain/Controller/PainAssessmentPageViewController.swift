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
    
    @IBOutlet weak var mildImage: UIImageView!
    
    private var cardNumber = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpCardCornerRadius()
        setUpCardShadow()
        
        mildImage.transform = CGAffineTransform(scaleX: -1 , y: 1)
    }
    
    
    
    @IBAction func moderateCardAreaPressed(_ sender: Any) {
        //card index number = 1 (Moderate)
        cardNumber = 1
        showAlert(cardIndexNumber: cardNumber)
    }
    
    @IBAction func mildCardAreaPressed(_ sender: Any) {
        //card index number = 2 (Mild)
        cardNumber = 2
        showAlert(cardIndexNumber: cardNumber)
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
            self.performSegue(withIdentifier: "goShowPlanSettings", sender: self)
        }))
        
        confirmationAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "goShowPlanSettings" {
            
            if cardNumber > 0 && cardNumber < 6 {
                        
                let move = segue.destination as! CompleteAndShowPlanPageViewController
                
                var breakInterval: Double = 0
                var notifyTime: Double = 0
                
                //TODO: send action code based on index
                /*
                 1. Moderate Card
                 2. Mild Card
                 3. No Symptom - Hectic Work
                 4. No Symptom - Busy Work
                 5. No Symptom - Normal Work
                 */
                
                switch cardNumber {
                case 1:
                    print("Moderate")
                    breakInterval = 3600 // 1h
                    notifyTime = 300 // 5m
                case 2:
                    print("Mild")
                    breakInterval = 7200 // 2h
                    notifyTime = 300 // 5m
                default:
                    print("## Error ##")
                }
                
                move.breakDuration = breakInterval
                move.notifyDuration = notifyTime
            }
        }
        else if segue.identifier == "showWorkingAssessModal" {
            _ = segue.destination as! WorkingAssessmentPageViewController
        }
        else if segue.identifier == "" {
            _ = segue.destination as! SymptomPageViewController
        }
        
        
    }
}
