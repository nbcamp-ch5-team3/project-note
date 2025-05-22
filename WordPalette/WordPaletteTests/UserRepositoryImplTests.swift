//
//  UserRepositoryImplTests.swift
//  WordPalette
//
//  Created by 박주성 on 5/22/25.
//

import XCTest
import RxSwift
@testable import WordPalette

final class UserRepositoryImplTests: XCTestCase {

    private var manager: CoreDataManager!
    private var repository: UserRepositoryImpl!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        manager = CoreDataManager(forTesting: true)
        repository = UserRepositoryImpl(coredataManager: manager)
        disposeBag = DisposeBag()
    }

    func testFetchUserDataReturnsValidScoreAndStudyHistory() async throws {
        let word = MockWordEntity.solvedWord
        
        try await manager.saveSolvedWord(word)

        let expectation = expectation(description: "Fetch UserData success")
        repository.fetchUserData()
            .subscribe(onSuccess: { userData in
                XCTAssertEqual(userData.score, 1)
                XCTAssertEqual(userData.studyHistorys.count, 1)
                XCTAssertTrue(Calendar.current.isDateInToday(userData.studyHistorys.first?.solvedAt ?? .distantPast))
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
