//
//  UnsolvedWordRepositoryImplTests.swift
//  WordPalette
//
//  Created by 박주성 on 5/22/25.
//


import XCTest
import RxSwift
@testable import WordPalette

final class UnsolvedWordRepositoryImplTests: XCTestCase {

    private var manager: CoreDataManager!
    private var repository: UnsolvedWordRepositoryImpl!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        manager = CoreDataManager(forTesting: true)
        let localDataSource = MockWordLocalDataSource()
        repository = UnsolvedWordRepositoryImpl(localDataSource: localDataSource, coredataManager: manager)
        disposeBag = DisposeBag()
    }
    
    func testSearchWordReturnsFilteredResults() {
        // given
        let expectation = expectation(description: "search results")
        
        repository.searchWord(keyword: "hello", level: .beginner)
            .subscribe(onSuccess: { words in
                XCTAssertEqual(words.count, 1)
                XCTAssertEqual(words.first?.word, "hello")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }

    func testSaveAndFetchWord() async throws {
        let word = MockWordEntity.unsolvedWord

        let saveExpectation = expectation(description: "Save Words success")
        repository.saveWord(word: word)
            .subscribe(onSuccess: { success in
                XCTAssertTrue(success)
                saveExpectation.fulfill()
            })
            .disposed(by: disposeBag)

        await fulfillment(of: [saveExpectation], timeout: 1.0)

        let fetchExpectation = expectation(description: "Fetch Words success")
        repository.fetchWords(for: .beginner)
            .subscribe(onSuccess: { words in
                XCTAssertEqual(words.count, 1)
                XCTAssertEqual(words.first?.word, word.word)
                fetchExpectation.fulfill()
            })
            .disposed(by: disposeBag)

        await fulfillment(of: [fetchExpectation], timeout: 1.0)
    }

    func testDeleteWord() async throws {
        let word = MockWordEntity.unsolvedWord

        try await manager.saveUnsolvedWord(word)

        let deleteExpectation = expectation(description: "delete word")
        repository.deleteWord(by: word.id)
            .subscribe(onSuccess: { success in
                XCTAssertTrue(success)
                deleteExpectation.fulfill()
            })
            .disposed(by: disposeBag)

        await fulfillment(of: [deleteExpectation], timeout: 1.0)

        let remaining = try await manager.fetchUnsolvedWords(for: .beginner)
        XCTAssertTrue(remaining.isEmpty)
    }
}
