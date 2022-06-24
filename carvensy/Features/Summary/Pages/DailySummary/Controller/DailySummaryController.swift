//
//  DailySummaryController.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 21/06/22.
//

import UIKit

class DailySummaryController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var breakCV: UICollectionView!
    @IBOutlet weak var stretchCV: UICollectionView!
    @IBOutlet weak var stretchPlanTableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    
    var dailySession: Session?
    var sessionHelper = SessionCRUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let allSession = sessionHelper.fetchSession()
        dailySession = sessionHelper.currentSession(sessions: allSession)
        
        self.stretchPlanTableView.register(UINib(nibName: "ChooseStretchTableViewCell", bundle: nil), forCellReuseIdentifier: "stretch-type")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneAction(_ sender: Any) {
        performSegue(withIdentifier: "goToPainAssess", sender: self)
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
            let time = secondsToHourMinutesSeconds(Int(dailySession?.break_relation?.total_duration ?? 0))
            let amount = Int(dailySession?.break_relation?.break_amount ?? 0)
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
            let time = secondsToHourMinutesSeconds(Int(dailySession?.stretch?.total_stretch_duration ?? 0))
            let amount = Int(dailySession?.stretch?.stretch_amount ?? 0)
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
