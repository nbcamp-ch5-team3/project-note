//
//  CoreDataStack.swift
//  WordPalette
//
//  Created by 박주성 on 5/26/25.
//

import CoreData

final class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    let container: NSPersistentContainer
    let backgroundContext: NSManagedObjectContext

    private init() {
        container = NSPersistentContainer(name: "WordPalette")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data 로딩 실패: \(error), \(error.userInfo)")
            }
        }
        backgroundContext = container.newBackgroundContext()
    }
}
