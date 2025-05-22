//
//  SolvedWordRepositoryImplTests.swift
//  WordPaletteTests
//
//  Created by 박주성 on 5/22/25.
//

import XCTest
import RxSwift
@testable import WordPalette

final class SolvedWordRepositoryImplTests: XCTestCase {

    private var manager: CoreDataManager!
    private var repository: SolvedWordRepositoryImpl!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        manager = CoreDataManager(forTesting: true)
        repository = SolvedWordRepositoryImpl(coredataManager: manager)
        disposeBag = DisposeBag()
    }

    func testSaveAndFetchSolvedWord() async throws {
        let word = MockWordEntity.solvedWord

        let saveExpectation = expectation(description: "Save Word success")
        repository.saveWord(word: word)
            .subscribe(onSuccess: { success in
                XCTAssertTrue(success)
                saveExpectation.fulfill()
            })
            .disposed(by: disposeBag)

        await fulfillment(of: [saveExpectation], timeout: 1.0)

        let user = try await manager.fetchOrCreateUser()
        guard let study = user.studys?.firstObject as? StudyObject else {
            XCTFail("Study가 생성되지 않았습니다.")
            return
        }

        let fetchExpectation = expectation(description: "Fetch Words success")
        repository.fetchWords(id: study.id)
            .subscribe(onSuccess: { words in
                XCTAssertEqual(words.count, 1)
                XCTAssertEqual(words.first?.isCorrect, true)
                XCTAssertEqual(words.first?.word, "solve")
                fetchExpectation.fulfill()
            })
            .disposed(by: disposeBag)

        await fulfillment(of: [fetchExpectation], timeout: 1.0)
    }

}

