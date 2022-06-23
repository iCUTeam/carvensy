//
//  OverviewPageController.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 17/06/22.
//

import UIKit

class OverviewPageController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "overview-cell", for: indexPath) as! OverviewCollectionViewCell
        
        let breakTitle = ["Break Amount", "Total Break Duration"]
        let stretchTitle = ["Stretch Amount", "Total Stretch Duration"]
        
        if collectionView == self.breakCV
        {
            let time = secondsToHourMinutesSeconds(Int(lastSession?.break_relation?.total_duration ?? 0))
            let amount = Int(lastSession?.break_relation?.break_amount ?? 0)
            cell.infoType.text = breakTitle[indexPath.row]
            
            if indexPath.row == 0
            {
                cell.dataLbl.text = "\(amount) time(s)"
            }
            
            else
            {
                cell.dataLbl.text = makeTimeString(hour: time.0, min: time.1, sec: time.2)
            }
        }
        
        else
        {
            let time = secondsToHourMinutesSeconds(Int(lastSession?.stretch?.total_stretch_duration ?? 0))
            let amount = Int(lastSession?.stretch?.stretch_amount ?? 0)
            cell.infoType.text = stretchTitle[indexPath.row]
            
            if indexPath.row == 0
            {
                cell.dataLbl.text = "\(amount) time(s)"
            }
            
            else
            {
                cell.dataLbl.text = makeTimeString(hour: time.0, min: time.1, sec: time.2)
            }
        }
        
        return cell
    }

}
