//
//  SessionCRUD.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 22/06/22.
//

import Foundation
import CoreData

class SessionCRUD
{
    let coreDataHelper = CoreDataHelper()
    
    //fetch session
    
    func fetchSession() -> [Session]
    {
        let context = coreDataHelper.getBackgroundContext()
        
        let sort = NSSortDescriptor(key: "date", ascending: false)
        
        let fetchRequest = Session.fetchRequest()
        
        fetchRequest.sortDescriptors = [sort]
        
        do
        {
            let session = try context.fetch(fetchRequest)
       
            return session
        }
        
        catch
        {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    //convert to single session
    
    func currentSession(sessions: [Session]) -> Session
    {
        let context = coreDataHelper.getBackgroundContext()
        let session = Session(context: context)
        
        guard let current_session = sessions.first else { return session}
        
        return current_session
    }
    
    //make first session + add to user
    
    func newSession(User: User)
    {
        let context = coreDataHelper.getBackgroundContext()
        
        let session = Session(context: context)
        
        User.addToSession(session)
   
        session.date = Date()
        
        coreDataHelper.saveContext(saveContext: context)
    }
    
    //add first break to session
    
    func firstBreak(Current_session: Session, duration: Double)
    {
        let context = coreDataHelper.getBackgroundContext()
        
        let breakRelation = Break(context: context)
        
        breakRelation.total_duration = duration
        breakRelation.break_amount = 1
        
        Current_session.break_relation = breakRelation
        
        coreDataHelper.saveContext(saveContext: context)
        
    }

    
    //add first stretch to session
    
    func firstStretch(Current_session: Session, duration: Double, plan: Double)
    {
        let context = coreDataHelper.getBackgroundContext()
        
        let stretch = Stretch(context: context)
        
        let stretch_detail = Stretch_detail(context: context)
        
        stretch_detail.stretch_plan_index = plan
        
        stretch.total_stretch_duration = duration
        stretch.stretch_amount = 1
        
        stretch.addToStretch_detail(stretch_detail)
        
        Current_session.stretch = stretch
        coreDataHelper.saveContext(saveContext: context)
    }
    
    //update session break
    
    func addBreak(Current_Session: Session, duration: Double)
    {
        let context = coreDataHelper.getBackgroundContext()
        
        Current_Session.break_relation?.total_duration += duration
        Current_Session.break_relation?.break_amount += 1
        
        coreDataHelper.saveContext(saveContext: context)
    }
    
    //update stretch
    
    func addStretch(Current_session: Session, duration: Double, plan: Double)
    {
        let context = coreDataHelper.getBackgroundContext()
        
        let stretch_detail = Stretch_detail(context: context)
        
        stretch_detail.stretch_plan_index = plan
        
        Current_session.stretch?.total_stretch_duration += duration
        Current_session.stretch?.stretch_amount += 1
        
        Current_session.stretch?.addToStretch_detail(stretch_detail)
        coreDataHelper.saveContext(saveContext: context)
    }
    
    //add pain assessment
    
    func addPainAssess(Current_session: Session, pain: Double)
    {
        let context = coreDataHelper.getBackgroundContext()
        
        Current_session.pain_assesment = pain
        
        coreDataHelper.saveContext(saveContext: context)
    }
    
    //add Symtomps
    
    func addSymtomps(Current_session: Session, symtomps: String)
    {
        let context = coreDataHelper.getBackgroundContext()
        
        let sessionDetail = Session_Detail(context: context)
        
        sessionDetail.symptoms = symtomps
        
        Current_session.addToSession_detail(sessionDetail)
        
        coreDataHelper.saveContext(saveContext: context)
    }
    
    //convert session detail NSSet to Array
    
    func sessDetailToArray(session: Session) -> [Session_Detail]
    {
        return session.session_detail?.allObjects as? [Session_Detail] ?? []
    }
    
    //convert stretch detail NSSet to Array
    
    func stretchDetailToArray(session: Session) -> [Stretch_detail]
    {
        return session.stretch?.stretch_detail?.allObjects as? [Stretch_detail] ?? []
    }

    
}
