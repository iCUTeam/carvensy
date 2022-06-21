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
    var quickStretchSteps = [StretchSteps]()
    var focusStretchSteps = [StretchSteps]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "ChooseStretchTableViewCell", bundle: nil), forCellReuseIdentifier: "stretch-type")
        
        stretchType.append(StretchType(title: "Quick Stretch (1 mins)", content: "Static - 4 Stretch Moves", icon: "Stop Stretch", steps: quickStretchSteps))
        stretchType.append(StretchType(title: "Focus Stretch (2 mins)", content: "Static - 4 Stretch Moves", icon: "Push Out Stretch", steps: focusStretchSteps))
        
        quickStretchSteps.append(StretchSteps(title: "Push Out", desc: "Interlace your fingers as shown on the guide. Then rotate your palms and push them out and away from your chest.", icon: "Push Out Stretch", reps: 2, holdSec: 5, bothHand: false))
        quickStretchSteps.append(StretchSteps(title: "Stop - Wrist Extension", desc: "Start by holding one hand up and extended all the way out. It’s as if you’re saying, “Stop!” With the other hand, reach out and pull your fingers back.", icon: "Stop Stretch", reps: 2, holdSec: 5, bothHand: true))
        quickStretchSteps.append(StretchSteps(title: "Prayer", desc: "At chest level, press both palms together as on the given guide, keeping your hands at the same level, slowly raise both elbows.", icon: "Prayer", reps: 2, holdSec: 5, bothHand: false))
        quickStretchSteps.append(StretchSteps(title: "Thumb Glide", desc: "As in the guide, start by grabbing your thumb. Then rotate it like a helicopter blade. When finished, gently pull your thumb backward.", icon: "Thumb Glide", reps: 2, holdSec: 5, bothHand: true))
        
        focusStretchSteps.append(StretchSteps(title: "Push Out", desc: "Interlace your fingers as shown on the guide. Then rotate your palms and push them out and away from your chest.", icon: "Push Out Stretch", reps: 2, holdSec: 10, bothHand: false))
        focusStretchSteps.append(StretchSteps(title: "Stop - Wrist Extension", desc: "Start by holding one hand up and extended all the way out. It’s as if you’re saying, “Stop!” With the other hand, reach out and pull your fingers back.", icon: "Stop Stretch", reps: 2, holdSec: 10, bothHand: true))
        focusStretchSteps.append(StretchSteps(title: "Prayer", desc: "At chest level, press both palms together as on the given guide, keeping your hands at the same level, slowly raise both elbows.", icon: "Prayer", reps: 2, holdSec: 10, bothHand: false))
        focusStretchSteps.append(StretchSteps(title: "Thumb Glide", desc: "As in the guide, start by grabbing your thumb. Then rotate it like a helicopter blade. When finished, gently pull your thumb backward.", icon: "Thumb Glide", reps: 2, holdSec: 10, bothHand: true))
        
        

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stretchType.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == stretchType.count + 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "more", for: indexPath) as! MoreComingSoonCell
            cell.layer.cornerRadius = 0.5
            
            return cell
        }
        
        else
        {
           let cell = tableView.dequeueReusableCell(withIdentifier: "stretch-type", for: indexPath) as! ChooseStretchTableViewCell
            
            let gifImage = UIImage.gifImageWithName(stretchType[indexPath.row].stretchIcon ?? "Stop Stretch")
            cell.stretchImage.image = gifImage
            cell.layer.cornerRadius = 0.5
            cell.stretchTitle.text = stretchType[indexPath.row].stretchTitle
            cell.stretchTypes.text = stretchType[indexPath.row].stretchContent
            cell.maxReps.text = "Max \(stretchType[indexPath.row].stretchSteps[indexPath.row].numberofReps ?? 0) reps per move"
            cell.maxHold.text = "Max \(stretchType[indexPath.row].stretchSteps[indexPath.row].holdSec ?? 0) secs hold each"
            
            return cell
        }
    
        
    }
}
