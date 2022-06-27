//
//  ChooseStretchController.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 15/06/22.
//

import UIKit

class ChooseStretchController: UIViewController, UITableViewDataSource, UITableViewDelegate{
   
    @IBOutlet var tableView: UITableView!
    
    var stretchType = [StretchType]()
    var dataSeeder = StretchSeeder()
    
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "ChooseStretchTableViewCell", bundle: nil), forCellReuseIdentifier: "stretch-type")
        self.tableView.register(UINib(nibName: "MoreComingSoonCell", bundle: nil), forCellReuseIdentifier: "more")
    
        stretchType = dataSeeder.seedData()
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return stretchType.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section < stretchType.count
        {
            index = indexPath.section
            performSegue(withIdentifier: "goToDisclaimer", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDisclaimer"
        {
            guard let vc = segue.destination as? DisclaimerController else { return }
            vc.modalPresentationStyle = .fullScreen
            vc.index = index
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == stretchType.count
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "more", for: indexPath) as! MoreComingSoonCell
            cell.layer.cornerRadius = 0.5
            
            return cell
        }
        
        else
        {
           let cell = tableView.dequeueReusableCell(withIdentifier: "stretch-type", for: indexPath) as! ChooseStretchTableViewCell
            
            let gifImage = UIImage.gifImageWithName(stretchType[indexPath.section].stretchIcon ?? "Stop Stretch")
            cell.stretchImage.image = gifImage
            cell.layer.cornerRadius = 50
            cell.stretchTitle.text = stretchType[indexPath.section].stretchTitle
            cell.stretchTypes.text = stretchType[indexPath.section].stretchContent
            cell.maxReps.text = "Max \(stretchType[indexPath.section].stretchSteps[1].numberofReps ?? 0) reps per move"
            cell.maxHold.text = "Max \(stretchType[indexPath.section].stretchSteps[indexPath.section].holdSec ?? 0) secs hold each"
            
            return cell
        }
    
        
    }
}
