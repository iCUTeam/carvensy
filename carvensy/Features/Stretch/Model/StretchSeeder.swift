//
//  StretchSeeder.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 27/06/22.
//

import Foundation

class StretchSeeder
{
    func seedData() ->  [StretchType]
    {
        var stretchType = [StretchType]()
        var quickStretchSteps = [StretchSteps]()
        var focusStretchSteps = [StretchSteps]()
        
        
        quickStretchSteps.append(StretchSteps(title: "Push Out", desc: "Interlace your fingers as shown on the guide. Then rotate your palms and push them out and away from your chest.", icon: "Push Out", reps: 2, holdSec: 5, bothHand: false))
        quickStretchSteps.append(StretchSteps(title: "Stop - Wrist Extension", desc: "Start by holding one hand up and extended all the way out. It’s as if you’re saying, “Stop!” With the other hand, reach out and pull your fingers back. Do it twice for both your hand", icon: "Stop Stretch", reps: 2, holdSec: 5, bothHand: true))
        quickStretchSteps.append(StretchSteps(title: "Prayer Pose", desc: "At chest level, press both palms together as on the given guide, keeping your hands at the same level, slowly raise both elbows.", icon: "Prayer Pose", reps: 2, holdSec: 5, bothHand: false))
        quickStretchSteps.append(StretchSteps(title: "Thumb Glide", desc: "As in the guide, start by grabbing your thumb. Then rotate it like a helicopter blade. When finished, gently pull your thumb backward. Do it twice for both your hand", icon: "Thumb Glides", reps: 2, holdSec: 5, bothHand: true))
        
        focusStretchSteps.append(StretchSteps(title: "Push Out", desc: "Interlace your fingers as shown on the guide. Then rotate your palms and push them out and away from your chest.", icon: "Push Out", reps: 2, holdSec: 10, bothHand: false))
        focusStretchSteps.append(StretchSteps(title: "Stop - Wrist Extension", desc: "Start by holding one hand up and extended all the way out. It’s as if you’re saying, “Stop!” With the other hand, reach out and pull your fingers back. Do it twice for both your hand", icon: "Stop Stretch", reps: 2, holdSec: 10, bothHand: true))
        focusStretchSteps.append(StretchSteps(title: "Prayer Pose", desc: "At chest level, press both palms together as on the given guide, keeping your hands at the same level, slowly raise both elbows.", icon: "Prayer Pose", reps: 2, holdSec: 10, bothHand: false))
        focusStretchSteps.append(StretchSteps(title: "Thumb Glide", desc: "As in the guide, start by grabbing your thumb. Then rotate it like a helicopter blade. When finished, gently pull your thumb backward. Do it twice for both your hand", icon: "Thumb Glides", reps: 2, holdSec: 10, bothHand: true))
        
        
        stretchType.append(StretchType(title: "Quick Stretch (1 mins)", content: "Static - 4 Stretch Moves", icon: "Stop Stretch", steps: quickStretchSteps))
        stretchType.append(StretchType(title: "Focus Stretch (2 mins)", content: "Static - 4 Stretch Moves", icon: "Push Out", steps: focusStretchSteps))
        
        return stretchType.sorted { stretch1, stretch2 in
            stretch1.stretchTitle! < stretch2.stretchTitle!
        }
    }
}
