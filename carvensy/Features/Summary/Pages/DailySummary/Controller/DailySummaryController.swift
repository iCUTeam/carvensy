//
//  DailySummaryController.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 21/06/22.
//

import UIKit

class DailySummaryController: UIViewController {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var breakCV: UICollectionView!
    @IBOutlet weak var stretchCV: UICollectionView!
    @IBOutlet weak var stretchPlanTableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneAction(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
