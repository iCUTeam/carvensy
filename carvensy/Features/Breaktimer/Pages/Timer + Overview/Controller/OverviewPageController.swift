//
//  OverviewPageController.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 17/06/22.
//

import UIKit

class OverviewPageController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate{

    var lastSession: Session?
    var sessionHelper = SessionCRUD()
    var symtomps = [Session_Detail]()
    
    @IBOutlet weak var breakCV: UICollectionView!
    @IBOutlet weak var stretchCV: UICollectionView!
    @IBOutlet weak var stretchPlanTableView: UITableView!
    @IBOutlet weak var emojiView: UIImageView!
    @IBOutlet weak var painAssessCV: UICollectionView!
    
    @IBOutlet weak var breakLbl: UILabel!
    @IBOutlet weak var stretchLbl: UILabel!
    @IBOutlet weak var routineLbl: UILabel!
    @IBOutlet weak var postLbl: UILabel!
    
    var emojiArray = ["post work - sad emoji", "post work - think emoji", "post work - flat emoji", "post work - smile emoji", "post work - happy emoji"]
    
    override func viewWillAppear(_ animated: Bool) {
        checkSession()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Overview"
        
        let allSession = sessionHelper.fetchSession()
        
        if allSession.count != 0
        {
            lastSession = allSession.first
        }
        
        if lastSession != nil
        {
            symtomps = sessionHelper.sessDetailToArray(session: lastSession!)
        }
        
        checkSession()
    
        self.stretchPlanTableView.register(UINib(nibName: "ChooseStretchTableViewCell", bundle: nil), forCellReuseIdentifier: "stretch-type")
       
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
            
            emojiView.image = UIImage(named: emojiArray[Int(lastSession?.pain_assesment ?? 2)])
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == painAssessCV
        {
            return symtomps.count
        }
        
        else
        {
            return 2
        }
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
        
        else if collectionView == self.painAssessCV
        {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "overview-symtomps", for: indexPath) as! OverviewSymptomsCollectionViewCell
            
            cell2.lbl.text = symtomps[indexPath.row].symptoms
            
            return cell2
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stretch-type") as! ChooseStretchTableViewCell
        let gifImage = UIImage.gifImageWithName(stretchType[0].stretchIcon ?? "Stop Stretch")
        cell.stretchImage.image = gifImage
        cell.layer.cornerRadius = 50
        cell.stretchTitle.text = stretchType[0].stretchTitle
        cell.stretchTypes.text = stretchType[0].stretchContent
        cell.maxReps.text = "Max \(stretchType[0].stretchSteps[1].numberofReps ?? 0) reps per move"
        cell.maxHold.text = "Max \(stretchType[0].stretchSteps[0].holdSec ?? 0) secs hold each"
        
        return cell
    }

}
