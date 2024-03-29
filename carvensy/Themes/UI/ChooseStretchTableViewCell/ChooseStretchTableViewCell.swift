//
//  ChooseStretchTableViewCell.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 15/06/22.
//

import UIKit

class ChooseStretchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableCellView: UIView!
    @IBOutlet weak var stretchImage: UIImageView!
    @IBOutlet weak var stretchTitle: UILabel!
    @IBOutlet weak var stretchTypes: UILabel!
    @IBOutlet weak var maxReps: UILabel!
    @IBOutlet weak var maxHold: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tableCellView.roundViewCorner([.topRight,.topLeft,.bottomRight,.bottomLeft], radius: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
