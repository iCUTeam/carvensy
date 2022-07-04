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
    
    var dateStart : Date?
    var dailySession: Session?
    var sessionHelper = SessionCRUD()
    var coreDataHelper = CoreDataHelper()
    var stretchType = [StretchType]()
    var dataSeeder = StretchSeeder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBtn.tintColor = UIColor(red: 0.00, green: 0.44, blue: 0.38, alpha: 1.00)
        
        let timezone = TimeZone.current
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timezone
        dateFormatter.dateFormat = "d MMM yyyy h:mm a"
        
        date.text = dateFormatter.string(from: dateStart ?? Date())

        stretchType = dataSeeder.seedData()
        let allSession = sessionHelper.fetchSession()

        if allSession.count != 0
        {
            dailySession = allSession.first
        }
        
//        dailySession = Session(context: coreDataHelper.getBackgroundContext())
//        
//        let breakDummy = Break(context: coreDataHelper.getBackgroundContext())
//        breakDummy.total_duration = 3600
//        breakDummy.break_amount = 4
//
//        let stretchDummy = Stretch(context: coreDataHelper.getBackgroundContext())
//        stretchDummy.total_stretch_duration = 300
//        stretchDummy.stretch_amount = 3
//
//        dailySession?.break_relation = breakDummy
//        dailySession?.stretch = stretchDummy
        
        self.stretchPlanTableView.register(UINib(nibName: "ChooseStretchTableViewCell", bundle: nil), forCellReuseIdentifier: "stretch-type")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneAction(_ sender: Any) {
        performSegue(withIdentifier: "goToPainAssess", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPainAssess"
        {
            guard let vc = segue.destination as? PainAssessmentController else {return}
            vc.session = dailySession
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
   
        
        let breakTitle = ["Break Amount", "Total Break Duration"]
        let stretchTitle = ["Stretch Amount", "Total Stretch Duration"]
        
        if collectionView == self.breakCV
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "summary-break", for: indexPath) as! OverviewCollectionViewCell
            
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
            
            return cell
        }
        
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "summary-stretch", for: indexPath) as! OverviewCollectionViewCell
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
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stretch-type") as! ChooseStretchTableViewCell
        let gifImage = UIImage.gifImageWithName(stretchType[0].stretchIcon ?? "Stop Stretch")
        cell.stretchImage.image = gifImage
        cell.layer.cornerRadius = 10
        cell.contentView.layer.cornerRadius = 10
        cell.stretchTitle.text = stretchType[0].stretchTitle
        cell.stretchTypes.text = stretchType[0].stretchContent
        cell.maxReps.text = "Max \(stretchType[0].stretchSteps[1].numberofReps ?? 0) reps per move"
        cell.maxHold.text = "Max \(stretchType[0].stretchSteps[0].holdSec ?? 0) secs hold each"
        return cell
    }
    
    func convertDateFormatToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy - HH:mm a"
        let resultString = dateFormatter.string(from: date)
        return resultString
    }
}
