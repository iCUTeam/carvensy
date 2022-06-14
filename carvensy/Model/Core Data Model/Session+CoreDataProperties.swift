//
//  Session+CoreDataProperties.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 14/06/22.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var pain_assesment: Double
    @NSManaged public var session_detail: NSSet?
    @NSManaged public var break: Break?
    @NSManaged public var stretch: Stretch?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for session_detail
extension Session {

    @objc(addSession_detailObject:)
    @NSManaged public func addToSession_detail(_ value: Session_Detail)

    @objc(removeSession_detailObject:)
    @NSManaged public func removeFromSession_detail(_ value: Session_Detail)

    @objc(addSession_detail:)
    @NSManaged public func addToSession_detail(_ values: NSSet)

    @objc(removeSession_detail:)
    @NSManaged public func removeFromSession_detail(_ values: NSSet)

}

extension Session : Identifiable {

}
