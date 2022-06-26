//
//  NewUser.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 22/06/22.
//

import UIKit
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
    
    func fetchUser() -> [User]
    {
        let context = coreDataHelper.getBackgroundContext()
        
        do
        {
            let user = try context.fetch(User.fetchRequest())
            
            return user
        }
        
        catch
        {
            print(error.localizedDescription)
        }
        
        return []
    }
    
}
