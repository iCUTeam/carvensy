//
//  Stretch Steps.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 15/06/22.
//

import Foundation
import UIKit

struct StretchSteps
{
    var stretchIcon: String?
    var stretchTitle: String?
    var stretchDesc: String?
    var numberofReps: Int?
    var holdSec: Int?
    var bothHand: Bool
    var totalDuration: Double?
    
    init(title: String?, desc: String?, icon: String?, reps: Int, holdSec: Int, bothHand: Bool, totalDuration: Double)
    {
        self.stretchTitle = title
        self.stretchDesc = desc
        self.stretchIcon = icon
        self.numberofReps = reps
        self.holdSec = holdSec
        self.bothHand = bothHand
        self.totalDuration = totalDuration
//        self.totalDuration = Double(reps * holdSec)
    }
}
