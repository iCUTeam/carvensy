//
//  OverviewPageController.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 17/06/22.
//

import UIKit

class OverviewPageController: UIViewController {

    var lastSession: Session?
    @IBOutlet weak var breakCV: UICollectionView!
    @IBOutlet weak var stretchCV: UICollectionView!
    @IBOutlet weak var stretchPlanTableView: UITableView!
    @IBOutlet weak var emojiView: UIImageView!
    @IBOutlet weak var painAssessCV: UICollectionView!
    
    @IBOutlet weak var breakLbl: UILabel!
    @IBOutlet weak var stretchLbl: UILabel!
    @IBOutlet weak var routineLbl: UILabel!
    @IBOutlet weak var postLbl: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        checkSession()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkSession()
        
       
        // Do any additional setup after loading the view.
    }
    
    
    
    private func checkSession()
    {
        if lastSession == nil
        {
            //add Image
            let textTitle = CATextLayer()
            textTitle.string = "Still got nothing here..."
            textTitle.font = UIFont(name: "SF-Pro", size: 24)
            
            let textContent = CATextLayer()
            textContent.string = "You haven't done any break or stretch sessions, try one and give your hands some love."
            textContent.font = UIFont(name: "SF-Pro", size: 16)
            
            view.layer.addSublayer(textTitle)
            view.layer.addSublayer(textContent)
            
            breakCV.isHidden = true
            stretchCV.isHidden = true
            stretchPlanTableView.isHidden = true
            emojiView.isHidden = true
            painAssessCV.isHidden = true
            breakLbl.isHidden = true
            stretchLbl.isHidden = true
            routineLbl.isHidden = true
            postLbl.isHidden = true
        }
        
        else
        {
            breakCV.isHidden = false
            stretchCV.isHidden = false
            stretchPlanTableView.isHidden = false
            emojiView.isHidden = false
            painAssessCV.isHidden = false
            breakLbl.isHidden = false
            stretchLbl.isHidden = false
            routineLbl.isHidden = false
            postLbl.isHidden = false
        }
    }

}
