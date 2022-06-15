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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "ChooseStretchTableViewCell", bundle: nil), forCellReuseIdentifier: "stretch-type")

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stretchType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stretch-type", for: indexPath) as! ChooseStretchTableViewCell
        
        cell.layer.cornerRadius = 0.5
        cell.stretchImage.image = UIImage(data: stretchType[indexPath.row].stretchIcon!)
        cell.stretchTitle.text = stretchType[indexPath.row].stretchTitle
        cell.stretchContent.text = stretchType[indexPath.row].stretchContent
        
        return cell
    }
}
