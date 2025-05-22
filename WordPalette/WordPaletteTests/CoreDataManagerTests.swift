//
//  CoreDataManagerTests.swift
//  WordPalette
//
//  Created by 박주성 on 5/22/25.
//

import XCTest
@testable import WordPalette

final class CoreDataManagerTests: XCTestCase {
    
    private var manager: CoreDataManager!
    
    override func setUpWithError() throws {
        manager = CoreDataManager(forTesting: true)
    }
    
    func testSaveAndFetchUnsolvedWord() async throws {
        let word = MockWordEntity.unsolvedWord
        
        try await manager.saveUnsolvedWord(word)
        let words = try await manager.fetchUnsolvedWords(for: .beginner)
        
        XCTAssertEqual(words.count, 1)
        XCTAssertEqual(words.first?.word, "hello")
    }
    
    func testSaveAndFetchSolvedWord() async throws {
        let word = MockWordEntity.solvedWord
        
        try await manager.saveSolvedWord(word)
        
        let user = try await manager.fetchOrCreateUser()
        guard let study = user.studys?.firstObject as? StudyObject else {
            XCTFail("Study가 생성되지 않았습니다.")
            return
        }
        
        let words = try await manager.fetchSolvedWords(for: study.id)
        
        XCTAssertEqual(user.score, 1)
        XCTAssertTrue(Calendar.current.isDateInToday(study.solvedAt))
        XCTAssertEqual(words.count, 1)
        XCTAssertEqual(words.first?.isCorrect, true)
    }
    
    func testFetchOrCreateUser() async throws {
        let user1 = try await manager.fetchOrCreateUser()
        let user2 = try await manager.fetchOrCreateUser()
        XCTAssertEqual(user1, user2)
    }
    
    func testDeleteUnsolvedWord() async throws {
        let word = MockWordEntity.unsolvedWord
        
        try await manager.saveUnsolvedWord(word)
        try await manager.deleteUnsolvedWord(wordID: word.id)
        
        let words = try await manager.fetchUnsolvedWords(for: .beginner)
        XCTAssertTrue(words.isEmpty)
    }
}
