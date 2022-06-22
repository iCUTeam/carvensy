//
//  Stretch Type.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 15/06/22.
//

import Foundation
import UIKit

struct StretchType
{
    var stretchIcon: String?
    var stretchTitle: String?
    var stretchContent: String?
    var stretchSteps: [StretchSteps]
    
    init(title: String?, content: String?, icon: String?, steps: [StretchSteps])
    {
        self.stretchTitle = title
        self.stretchContent = content
        self.stretchIcon = icon
        self.stretchSteps = steps
    }
}


