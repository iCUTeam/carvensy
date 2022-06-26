//
//  BreakPlanCRUD.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 22/06/22.
//

import UIKit
import CoreData

class BreakPlanRU
{
    let coreDataHelper = CoreDataHelper()
    
    //fetch breakplan
    
    func fetchBreakPlan() -> [Break_Plan]
    {
        let context = coreDataHelper.getBackgroundContext()
        
        do
        {
            let break_plan = try context.fetch(Break_Plan.fetchRequest())
            
            return break_plan
        }
        
        catch
        {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    
    //edit breakplan
    
    func editBreakPlan(BreakPlan: Break_Plan, break_every: Double, notify: Double, snooze: Bool, name: String)
    {
        let context = coreDataHelper.getBackgroundContext()
        
        BreakPlan.break_every = break_every
        BreakPlan.notify_before = notify
        BreakPlan.snooze = snooze
        BreakPlan.user?.name = name
        
        coreDataHelper.saveContext(saveContext: context)
    }
}
