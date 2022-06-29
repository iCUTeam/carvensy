//
//  StretchFinishPageController.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 16/06/22.
//

import UIKit

class StretchFinishPageController: UIViewController {

    @IBOutlet weak var endSetBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        endSetBtn.tintColor = UIColor(red: 0.00, green: 0.44, blue: 0.38, alpha: 1.00)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressEndStretchSet(_ sender: Any) {
        performSegue( withIdentifier: "toBreakPage", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBreakPage"
        {
            guard let vc = segue.destination as? BreakPageController else { return }
            vc.modalPresentationStyle = .fullScreen
        }
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
