//
//  ChooseStretchTableViewCell.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 15/06/22.
//

import UIKit

class ChooseStretchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stretchImage: UIImageView!
    @IBOutlet weak var stretchTitle: UILabel!
    @IBOutlet weak var stretchContent: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
