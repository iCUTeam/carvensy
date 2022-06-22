//
//  IntroductionPageViewController.swift
//  carvensy
//
//  Created by Ariel Waraney on 21/06/22.
//

import UIKit

class IntroductionPageViewController: UIViewController {
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var breakCardView: UIView!
    @IBOutlet weak var stretchCardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        breakCardView.roundViewCorner([.bottomRight,.bottomLeft,.topRight,.topLeft], radius: 10)
        stretchCardView.roundViewCorner([.bottomRight,.bottomLeft,.topRight,.topLeft], radius: 10)
    }
    
    @IBAction func aboutButtonPressed(_ sender: Any) {
        //TODO: Add CTS Information Page Modal View
        
    }
    

}

extension UIView {
    
    func roundViewCorner(_ corners: UIRectCorner, radius: CGFloat){
        if #available(iOS 11, *){
            var cornerMask = CACornerMask()
            if(corners.contains(.topLeft)){
                cornerMask.insert(.layerMinXMinYCorner)
            }
            if(corners.contains(.topRight)){
                cornerMask.insert(.layerMaxXMinYCorner)
            }
            if(corners.contains(.bottomLeft)){
                cornerMask.insert(.layerMinXMaxYCorner)
            }
            if(corners.contains(.bottomRight)){
                cornerMask.insert(.layerMaxXMaxYCorner)
            }
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = cornerMask
        } else {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}
