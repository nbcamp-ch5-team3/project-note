//
//  SolvedWordObject+CoreDataProperties.swift
//  WordPalette
//
//  Created by 박주성 on 5/21/25.
//
//

import Foundation
import CoreData


extension SolvedWordObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SolvedWordObject> {
        return NSFetchRequest<SolvedWordObject>(entityName: "SolvedWordObject")
    }

    @NSManaged public var example: String
    @NSManaged public var id: UUID
    @NSManaged public var isCorrect: Bool
    @NSManaged public var level: String
    @NSManaged public var meaning: String
    @NSManaged public var word: String
    @NSManaged public var study: StudyObject?
}

extension SolvedWordObject : Identifiable {

}
