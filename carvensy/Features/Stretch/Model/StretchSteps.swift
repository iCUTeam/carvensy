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
    var stretchIcon: Data?
    var stretchTitle: String?
    var stretchDesc: String?
    var numberofReps: Int?
    var holdSec: Int?
    var isDone: Bool
    var bothHand: Bool
    
    init(title: String?, desc: String?, icon: Data?, reps: Int, holdSec: Int, bothHand: Bool)
    {
        self.stretchTitle = title
        self.stretchDesc = desc
        self.stretchIcon = icon
        self.numberofReps = reps
        self.holdSec = holdSec
        self.isDone = false
        self.bothHand = bothHand
    }
}
