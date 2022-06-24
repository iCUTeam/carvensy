//
//  ChooseStretchController.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 15/06/22.
//

import UIKit

var stretchType = [StretchType]()

class ChooseStretchController: UIViewController, UITableViewDataSource, UITableViewDelegate{
   
    @IBOutlet var tableView: UITableView!
    var quickStretchSteps = [StretchSteps]()
    var focusStretchSteps = [StretchSteps]()
    
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        quickStretchSteps.removeAll()
        focusStretchSteps.removeAll()
        
        self.tableView.register(UINib(nibName: "ChooseStretchTableViewCell", bundle: nil), forCellReuseIdentifier: "stretch-type")
        self.tableView.register(UINib(nibName: "MoreComingSoonCell", bundle: nil), forCellReuseIdentifier: "more")
        
        quickStretchSteps.append(StretchSteps(title: "Push Out", desc: "Interlace your fingers as shown on the guide. Then rotate your palms and push them out and away from your chest.", icon: "Push Out", reps: 2, holdSec: 5, bothHand: false))
        quickStretchSteps.append(StretchSteps(title: "Stop - Wrist Extension", desc: "Start by holding one hand up and extended all the way out. It’s as if you’re saying, “Stop!” With the other hand, reach out and pull your fingers back.", icon: "Stop Stretch", reps: 2, holdSec: 5, bothHand: true))
        quickStretchSteps.append(StretchSteps(title: "Prayer Pose", desc: "At chest level, press both palms together as on the given guide, keeping your hands at the same level, slowly raise both elbows.", icon: "Prayer", reps: 2, holdSec: 5, bothHand: false))
        quickStretchSteps.append(StretchSteps(title: "Thumb Glide", desc: "As in the guide, start by grabbing your thumb. Then rotate it like a helicopter blade. When finished, gently pull your thumb backward.", icon: "Thumb Glides", reps: 2, holdSec: 5, bothHand: true))
        
        focusStretchSteps.append(StretchSteps(title: "Push Out", desc: "Interlace your fingers as shown on the guide. Then rotate your palms and push them out and away from your chest.", icon: "Push Out", reps: 2, holdSec: 10, bothHand: false))
        focusStretchSteps.append(StretchSteps(title: "Stop - Wrist Extension", desc: "Start by holding one hand up and extended all the way out. It’s as if you’re saying, “Stop!” With the other hand, reach out and pull your fingers back.", icon: "Stop Stretch", reps: 2, holdSec: 10, bothHand: true))
        focusStretchSteps.append(StretchSteps(title: "Prayer Pose", desc: "At chest level, press both palms together as on the given guide, keeping your hands at the same level, slowly raise both elbows.", icon: "Prayer", reps: 2, holdSec: 10, bothHand: false))
        focusStretchSteps.append(StretchSteps(title: "Thumb Glide", desc: "As in the guide, start by grabbing your thumb. Then rotate it like a helicopter blade. When finished, gently pull your thumb backward.", icon: "Thumb Glides", reps: 2, holdSec: 10, bothHand: true))
        
        
        stretchType.append(StretchType(title: "Quick Stretch (1 mins)", content: "Static - 4 Stretch Moves", icon: "Stop Stretch", steps: quickStretchSteps))
        stretchType.append(StretchType(title: "Focus Stretch (2 mins)", content: "Static - 4 Stretch Moves", icon: "Push Out", steps: focusStretchSteps))
        
        

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
            performSegue(withIdentifier: "goToSteps", sender: self)
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
