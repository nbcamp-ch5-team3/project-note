//
//  CoreDataManager.swift
//  WordPalette
//
//  Created by 박주성 on 5/21/25.
//

import Foundation
import CoreData

actor CoreDataManager {
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    init() {
        self.container = NSPersistentContainer(name: "WordPalette")
        self.container.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data 로딩 실패: \(error)")
            }
        }
        self.context = container.newBackgroundContext()
    }
    
    // 테스트용 생성자
    init(forTesting: Bool) {
        self.container = NSPersistentContainer(name: "WordPalette")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        self.container.persistentStoreDescriptions = [description]
        self.container.loadPersistentStores { _, error in
            if let error {
                fatalError("테스트용 Core Data 로딩 실패: \(error)")
            }
        }
        self.context = container.newBackgroundContext()
    }
    
    // MARK: - Private Method

    private func fetchOrCreateTodayStudy(for user: UserObject) throws -> StudyObject {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

        let request = StudyObject.fetchRequest()
        request.predicate = NSPredicate(
            format: "solvedAt >= %@ AND solvedAt < %@",
            startOfDay as NSDate, endOfDay as NSDate
        )

        if let study = try context.fetch(request).first {
            return study
        } else {
            let newStudy = StudyObject(context: context)
            newStudy.id = UUID()
            newStudy.solvedAt = now
            newStudy.user = user
            user.addToStudys(newStudy)
            return newStudy
        }
    }

    // MARK: - Create
    
    func saveUnsolvedWord(_ word: WordEntity) async throws {
        try await context.perform {
            let object = UnsolvedWordObject(context: self.context)
            object.id = word.id
            object.word = word.word
            object.meaning = word.meaning
            object.example = word.example
            object.level = word.level.rawValue
            object.source = word.source.rawValue
            try self.context.save()
        }        
    }
    
    func saveSolvedWord(_ word: WordEntity) async throws {
        try await context.perform {
            let user = try self.fetchOrCreateUser()
            let study = try self.fetchOrCreateTodayStudy(for: user)
            
            let object = SolvedWordObject(context: self.context)
            object.id = word.id
            object.word = word.word
            object.meaning = word.meaning
            object.example = word.example
            object.level = word.level.rawValue
            
            if let isCorrect = word.isCorrect {
                object.isCorrect = isCorrect
            }

            study.addToWords(object)
            user.score += 1

            try self.context.save()
        }
    }

    // MARK: - Read
    
    func fetchUnsolvedWords(for level: Level) async throws -> [UnsolvedWordObject] {
        try await context.perform {
            let request = UnsolvedWordObject.fetchRequest()
            return try self.context.fetch(request)
        }
    }
    
    func fetchSolvedWords(for studyID: UUID) async throws -> [SolvedWordObject] {
        try await context.perform {
            let request = StudyObject.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", studyID as CVarArg)

            guard let study = try self.context.fetch(request).first,
                  let orderedSet = study.words else {
                return []
            }

            return orderedSet.array as? [SolvedWordObject] ?? []
        }
    }
    
    func fetchUnsolvedWordsByLevel(_ level: Level) async throws -> [UnsolvedWordObject] {
        try await context.perform {
            let request = UnsolvedWordObject.fetchRequest()
            request.predicate = NSPredicate(format: "level == %@", level.rawValue)
            return try self.context.fetch(request)
        }
    }
    
    func fetchOrCreateUser() throws -> UserObject {
        let request = UserObject.fetchRequest()
        if let user = try context.fetch(request).first {
            return user
        } else {
            let newUser = UserObject(context: context)
            newUser.score = 0
            return newUser
        }
    }
    
    // MARK: - Delete
    
    func deleteUnsolvedWord(wordID: UUID) async throws {
        try await context.perform {
            let request = UnsolvedWordObject.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", wordID as CVarArg)
            
            guard let word = try self.context.fetch(request).first else { return }
            self.context.delete(word)
            try self.context.save()
        }
    }
    
    func deleteAllUnsolvedWords() async throws {
        try await context.perform {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: UnsolvedWordObject.fetchRequest())
            try self.context.execute(deleteRequest)
        }
    }
}
