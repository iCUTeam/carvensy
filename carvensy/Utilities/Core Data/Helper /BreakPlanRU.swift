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
    
    //convert to single breakplan
    
    func currentBreakPlan(break_plans: [Break_Plan]) -> Break_Plan
    {
        let context = coreDataHelper.getBackgroundContext()
        let break_plan = Break_Plan(context: context)
        break_plan.notify_before = 300
        break_plan.break_every = 3600
        break_plan.snooze = false
        
        guard let curr_plan = break_plans.first else { return break_plan }
        
        return curr_plan
    }
    
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
