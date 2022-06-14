//
//  Break+CoreDataProperties.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 14/06/22.
//
//

import Foundation
import CoreData


extension Break {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Break> {
        return NSFetchRequest<Break>(entityName: "Break")
    }

    @NSManaged public var break_amount: Double
    @NSManaged public var total_duration: Date?
    @NSManaged public var session: Session?

}

extension Break : Identifiable {

}
