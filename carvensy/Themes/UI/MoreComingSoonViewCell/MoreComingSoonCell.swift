//
//  MoreComingSoonCell.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 20/06/22.
//

import UIKit

class MoreComingSoonCell: UITableViewCell {
    
    @IBOutlet weak var tableCellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tableCellView.roundViewCorner([.bottomLeft,.bottomRight,.topLeft,.topRight], radius: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
