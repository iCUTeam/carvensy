//
//  BreakPlanCRUD.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 22/06/22.
//

import Foundation
import CoreData

class BreakPlanRU
{
    let coreDataHelper = CoreDataHelper()
    
    //fetch breakplan
    
    //edit breakplan
    
    func editBreakPlan(BreakPlan: Break_Plan, break_every: Double, notify: Double, snooze: Bool)
    {
        let context = coreDataHelper.getBackgroundContext()
        
        BreakPlan.break_every = break_every
        BreakPlan.notify_before = notify
        BreakPlan.snooze = snooze
        
        coreDataHelper.saveContext(saveContext: context)
    }
}
