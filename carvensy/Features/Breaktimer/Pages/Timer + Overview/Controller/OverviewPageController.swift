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
        }
    }

}
