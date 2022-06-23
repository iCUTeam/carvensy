//
//  CoreDataHelper.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 22/06/22.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper {
    
    let container: NSPersistentContainer!
    let viewContext: NSManagedObjectContext!
    
    init() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        container = appDelegate?.persistentContainer
        viewContext = container.viewContext
    }
    
    func getBackgroundContext() -> NSManagedObjectContext {
        if let context = container?.newBackgroundContext() {
            return context
        } else {
            return viewContext
        }
    }
    
    func saveContext(saveContext: NSManagedObjectContext? = nil) {
        guard let context = saveContext else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
}
