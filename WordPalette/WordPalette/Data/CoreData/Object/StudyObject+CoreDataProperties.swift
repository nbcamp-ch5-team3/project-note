//
//  StudyObject+CoreDataProperties.swift
//  WordPalette
//
//  Created by 박주성 on 5/21/25.
//
//

import Foundation
import CoreData


extension StudyObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudyObject> {
        return NSFetchRequest<StudyObject>(entityName: "StudyObject")
    }

    @NSManaged public var id: UUID
    @NSManaged public var solvedAt: Date
    @NSManaged public var user: UserObject?
    @NSManaged public var words: NSOrderedSet?

}

// MARK: Generated accessors for words
extension StudyObject {

    @objc(insertObject:inWordsAtIndex:)
    @NSManaged public func insertIntoWords(_ value: SolvedWordObject, at idx: Int)

    @objc(removeObjectFromWordsAtIndex:)
    @NSManaged public func removeFromWords(at idx: Int)

    @objc(insertWords:atIndexes:)
    @NSManaged public func insertIntoWords(_ values: [SolvedWordObject], at indexes: NSIndexSet)

    @objc(removeWordsAtIndexes:)
    @NSManaged public func removeFromWords(at indexes: NSIndexSet)

    @objc(replaceObjectInWordsAtIndex:withObject:)
    @NSManaged public func replaceWords(at idx: Int, with value: SolvedWordObject)

    @objc(replaceWordsAtIndexes:withWords:)
    @NSManaged public func replaceWords(at indexes: NSIndexSet, with values: [SolvedWordObject])

    @objc(addWordsObject:)
    @NSManaged public func addToWords(_ value: SolvedWordObject)

    @objc(removeWordsObject:)
    @NSManaged public func removeFromWords(_ value: SolvedWordObject)

    @objc(addWords:)
    @NSManaged public func addToWords(_ values: NSOrderedSet)

    @objc(removeWords:)
    @NSManaged public func removeFromWords(_ values: NSOrderedSet)

}

extension StudyObject : Identifiable {

}
