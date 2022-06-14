//
//  Break_Plan+CoreDataProperties.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 14/06/22.
//
//

import Foundation
import CoreData


extension Break_Plan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Break_Plan> {
        return NSFetchRequest<Break_Plan>(entityName: "Break_Plan")
    }

    @NSManaged public var break_every: Date?
    @NSManaged public var notify_before: Date?
    @NSManaged public var snooze: Bool
    @NSManaged public var user: User?

}

extension Break_Plan : Identifiable {

}
