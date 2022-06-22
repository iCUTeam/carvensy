//
//  NewUser.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 22/06/22.
//

import Foundation
import CoreData

class NewUser
{
    let coreDataHelper = CoreDataHelper()
    
    //add new user + break plan
    
    func newUser(name: String, break_every: Double, notify: Double, snooze: Bool)
    {
        let context = coreDataHelper.getBackgroundContext()
        
        let user = User(context: context)
        let breakPlan = Break_Plan(context: context)
        
        user.name = name
        breakPlan.break_every = break_every
        breakPlan.notify_before = notify
        breakPlan.snooze = snooze
        
        user.break_plan = breakPlan
        
        coreDataHelper.saveContext(saveContext: context)
    }
    
    //fetch user
}
