//
//  User+CoreDataProperties.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 14/06/22.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var break_plan: Break_Plan?
    @NSManaged public var session: NSSet?

}

// MARK: Generated accessors for session
extension User {

    @objc(addSessionObject:)
    @NSManaged public func addToSession(_ value: Session)

    @objc(removeSessionObject:)
    @NSManaged public func removeFromSession(_ value: Session)

    @objc(addSession:)
    @NSManaged public func addToSession(_ values: NSSet)

    @objc(removeSession:)
    @NSManaged public func removeFromSession(_ values: NSSet)

}

extension User : Identifiable {

}
