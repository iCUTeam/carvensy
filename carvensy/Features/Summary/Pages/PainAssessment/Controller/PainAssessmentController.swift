//
//  PainAssessmentController.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 21/06/22.
//

import UIKit

class PainAssessmentController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    
    @IBOutlet weak var painAssessmentCV: UICollectionView!
    @IBOutlet weak var symtompsCV: UICollectionView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var postAssessTxt: UITextView!
    
    var emojiImgs = ["post work - sad emoji", "post work - think emoji", "post work - flat emoji", "post work - smile emoji", "post work - happy emoji"]
    var descImg = ["Worsen", "", "", "", "Better"]
    var symtomps = ["Pain", "Tremor", "Tingling", "Numbness", "Burning", "Itching", "Swollen", "Stiffness", "Weakness"]
    
    
    var session: Session?
    
    var sessionHelper = SessionCRUD()
    
    var painlevel: Double = 0
    
    var selectedSymtomps = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitBtn.isEnabled = false
        
        let allSession = sessionHelper.fetchSession()
        
        if allSession.count != 0
        {
            session = allSession.first
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitAction(_ sender: Any?)
    {
        sessionHelper.addPainAssess(Current_session: session!, pain: painlevel)
        
        for x in 0..<symtomps.count
        {
            if selectedSymtomps[x] == 1
            {
                sessionHelper.addSymtomps(Current_session: session!, symtomps: symtomps[x])
            }
        }
        
        performSegue(withIdentifier: "goToPostWork", sender: self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.painAssessmentCV
        {
            return 5
        }
        
        else
        {
            return 3
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.painAssessmentCV
        {
            return 1
        }
        
        else
        {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       
        
        if collectionView == self.painAssessmentCV
        {
            painlevel = Double(indexPath.row)
            submitBtn.isEnabled = true
            
        }
        
        else
        {
            selectedSymtomps[indexPath.row] = 1
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
      
        
        if collectionView == self.painAssessmentCV
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smile-pain", for: indexPath) as! PainAssessCollectionViewCell
            cell.emojiImg.image = UIImage(named: emojiImgs[indexPath.row])
            
            if Int(painlevel) == indexPath.row
            {
                cell.emojiImg.layer.borderWidth = 1
                cell.emojiImg.layer.borderColor = CarvensyColor.greenMain?.cgColor
                cell.emojiImg.layer.masksToBounds = false
                cell.emojiImg.layer.cornerRadius = cell.emojiImg.frame.height/2
                cell.emojiImg.clipsToBounds = true
            }
            
            cell.conditionLbl.text = descImg[indexPath.row]
            
            
            return cell
        }
        
        else
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "symtomps-det", for: indexPath) as! SymtompssCollectionViewCell
            
            if selectedSymtomps[indexPath.row] == 1
            {
                cell.backgroundColor = CarvensyColor.greenMain
            }
            
            else
            {
                cell.backgroundColor = CarvensyColor.greenAccent
            }
            
            cell.symtompsLbl.text = symtomps[indexPath.row]
    
            
            return cell
        }
        
    }
    
    

}
