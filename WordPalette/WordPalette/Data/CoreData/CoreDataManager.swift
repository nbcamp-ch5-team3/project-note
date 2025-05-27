//
//  CoreDataManager.swift
//  WordPalette
//
//  Created by 박주성 on 5/21/25.
//

import Foundation
import CoreData

actor CoreDataManager {
    
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.backgroundContext) {
         self.context = context
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
            do {
                let fetchRequest = UnsolvedWordObject.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "word == %@", word.word)
                
                let existing = try self.context.fetch(fetchRequest)
                if !existing.isEmpty {
                    throw CoreDataErrorType.duplicate
                }
                
                let object = UnsolvedWordObject(context: self.context)
                object.id = word.id
                object.word = word.word
                object.meaning = word.meaning
                object.example = word.example
                object.level = word.level.rawValue
                
                try self.context.save()
            } catch {
                throw CoreDataErrorType.saveFailed
            }
        }
    }
    
    func saveSolvedWord(_ word: WordEntity) async throws {
        try await context.perform {
            do {
                let user = try self.fetchOrCreateUser()
                let study = try self.fetchOrCreateTodayStudy(for: user)
                
                let isSaved = study.words?
                    .compactMap { $0 as? SolvedWordObject }
                    .contains(where: { $0.id == word.id }) ?? false

                if isSaved {
                    throw CoreDataErrorType.duplicate
                }
                
                let object = SolvedWordObject(context: self.context)
                object.id = word.id
                object.word = word.word
                object.meaning = word.meaning
                object.example = word.example
                object.level = word.level.rawValue
                object.isCorrect = word.isCorrect ?? false
                
                study.addToWords(object)
                user.score += 1
                
                try self.context.save()
            } catch {
                throw CoreDataErrorType.saveFailed
            }
        }
    }
    
    // MARK: - Read
    
    func fetchUnsolvedWords(for level: Level) async throws -> [UnsolvedWordObject] {
        try await context.perform {
            do {
                let request = UnsolvedWordObject.fetchRequest()
                request.predicate = NSPredicate(format: "level == %@", level.rawValue)
                return try self.context.fetch(request)
            } catch {
                throw CoreDataErrorType.fetchFailed
            }
        }
    }
    
    func fetchSolvedWords(for studyID: UUID) async throws -> [SolvedWordObject] {
        try await context.perform {
            do {
                let request = StudyObject.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", studyID as CVarArg)
                
                guard let study = try self.context.fetch(request).first,
                      let orderedSet = study.words else {
                    return []
                }
                
                return orderedSet.array as? [SolvedWordObject] ?? []
            } catch {
                throw CoreDataErrorType.fetchFailed
            }
        }
    }
    
    func fetchTodaySolvedWords() async throws -> [SolvedWordObject] {
        try await context.perform {
            let user = try self.fetchOrCreateUser()
            let study = try self.fetchOrCreateTodayStudy(for: user)
            
            guard let words = study.words?.array as? [SolvedWordObject] else {
                throw CoreDataErrorType.fetchFailed
            }
            
            return words
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
            do {
                let request = UnsolvedWordObject.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", wordID as CVarArg)
                guard let word = try self.context.fetch(request).first else { return }
                self.context.delete(word)
                try self.context.save()
            } catch {
                throw CoreDataErrorType.deleteFailed
            }
        }
    }

    func deleteAllUnsolvedWords(for level: Level) async throws {
        try await context.perform {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UnsolvedWordObject")
            request.predicate = NSPredicate(format: "level == %@", level.rawValue)

            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            try self.context.execute(deleteRequest)
            try self.context.save()

        }
    }
}
