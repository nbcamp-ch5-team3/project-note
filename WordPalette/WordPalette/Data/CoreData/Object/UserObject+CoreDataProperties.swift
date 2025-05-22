//
//  UserObject+CoreDataProperties.swift
//  WordPalette
//
//  Created by 박주성 on 5/21/25.
//
//

import Foundation
import CoreData


extension UserObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserObject> {
        return NSFetchRequest<UserObject>(entityName: "UserObject")
    }

    @NSManaged public var score: Int64
    @NSManaged public var studys: NSOrderedSet?

}

// MARK: Generated accessors for studys
extension UserObject {

    @objc(insertObject:inStudysAtIndex:)
    @NSManaged public func insertIntoStudys(_ value: StudyObject, at idx: Int)

    @objc(removeObjectFromStudysAtIndex:)
    @NSManaged public func removeFromStudys(at idx: Int)

    @objc(insertStudys:atIndexes:)
    @NSManaged public func insertIntoStudys(_ values: [StudyObject], at indexes: NSIndexSet)

    @objc(removeStudysAtIndexes:)
    @NSManaged public func removeFromStudys(at indexes: NSIndexSet)

    @objc(replaceObjectInStudysAtIndex:withObject:)
    @NSManaged public func replaceStudys(at idx: Int, with value: StudyObject)

    @objc(replaceStudysAtIndexes:withStudys:)
    @NSManaged public func replaceStudys(at indexes: NSIndexSet, with values: [StudyObject])

    @objc(addStudysObject:)
    @NSManaged public func addToStudys(_ value: StudyObject)

    @objc(removeStudysObject:)
    @NSManaged public func removeFromStudys(_ value: StudyObject)

    @objc(addStudys:)
    @NSManaged public func addToStudys(_ values: NSOrderedSet)

    @objc(removeStudys:)
    @NSManaged public func removeFromStudys(_ values: NSOrderedSet)

}

extension UserObject : Identifiable {

}
