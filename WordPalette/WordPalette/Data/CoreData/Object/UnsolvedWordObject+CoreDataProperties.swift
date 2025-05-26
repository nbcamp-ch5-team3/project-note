//
//  UnsolvedWordObject+CoreDataProperties.swift
//  WordPalette
//
//  Created by 박주성 on 5/21/25.
//
//

import Foundation
import CoreData


extension UnsolvedWordObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UnsolvedWordObject> {
        return NSFetchRequest<UnsolvedWordObject>(entityName: "UnsolvedWordObject")
    }

    @NSManaged public var example: String
    @NSManaged public var id: UUID
    @NSManaged public var isCorrect: Bool
    @NSManaged public var level: String
    @NSManaged public var meaning: String
    @NSManaged public var word: String
    @NSManaged public var source: Int16
}

extension UnsolvedWordObject : Identifiable {

}
