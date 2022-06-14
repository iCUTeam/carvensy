//
//  Session_Detail+CoreDataProperties.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 14/06/22.
//
//

import Foundation
import CoreData


extension Session_Detail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session_Detail> {
        return NSFetchRequest<Session_Detail>(entityName: "Session_Detail")
    }

    @NSManaged public var symptoms: String?
    @NSManaged public var session: Session?

}

extension Session_Detail : Identifiable {

}
