//
//  TestCoreDataStack.swift
//  WordPalette
//
//  Created by 박주성 on 5/26/25.
//

import CoreData

final class TestCoreDataStack {
    
    static let shared = TestCoreDataStack()
    
    let container: NSPersistentContainer
    let backgroundContext: NSManagedObjectContext

    private init() {
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType

        container = NSPersistentContainer(name: "WordPalette")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data 로딩 실패: \(error), \(error.userInfo)")
            }
        }
        backgroundContext = container.newBackgroundContext()
    }
}
