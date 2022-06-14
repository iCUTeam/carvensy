//
//  Stretch+CoreDataProperties.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 14/06/22.
//
//

import Foundation
import CoreData


extension Stretch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stretch> {
        return NSFetchRequest<Stretch>(entityName: "Stretch")
    }

    @NSManaged public var stretch_amount: Double
    @NSManaged public var total_stretch_duration: Date?
    @NSManaged public var session: Session?
    @NSManaged public var stretch_detail: NSSet?

}

// MARK: Generated accessors for stretch_detail
extension Stretch {

    @objc(addStretch_detailObject:)
    @NSManaged public func addToStretch_detail(_ value: Stretch_detail)

    @objc(removeStretch_detailObject:)
    @NSManaged public func removeFromStretch_detail(_ value: Stretch_detail)

    @objc(addStretch_detail:)
    @NSManaged public func addToStretch_detail(_ values: NSSet)

    @objc(removeStretch_detail:)
    @NSManaged public func removeFromStretch_detail(_ values: NSSet)

}

extension Stretch : Identifiable {

}
