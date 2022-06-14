//
//  Stretch_detail+CoreDataProperties.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 14/06/22.
//
//

import Foundation
import CoreData


extension Stretch_detail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stretch_detail> {
        return NSFetchRequest<Stretch_detail>(entityName: "Stretch_detail")
    }

    @NSManaged public var stretch_plan_index: Double
    @NSManaged public var stretch: Stretch?

}

extension Stretch_detail : Identifiable {

}
