//
//  UserRepositoryImpl.swift
//  WordPalette
//
//  Created by 박주성 on 5/21/25.
//

import Foundation
import RxSwift

final class UserRepositoryImpl: UserRepository {
    
    private let coreDataManager: CoreDataManager
    
    init(coredataManager: CoreDataManager) {
        self.coreDataManager = coredataManager
    }
    
    private func toEntity(_ user: UserObject) -> UserData {
        guard let studys = user.studys?.array as? [StudyObject],
              let studyID = studys.first?.id
        else { return UserData(score: 0, studyHistorys: []) }
        
        let solvedAts = studys.compactMap { $0.solvedAt }
        let history = solvedAts.map { StudyHistory(id: studyID, solvedAt: $0) }

        return UserData(score: Int(user.score), studyHistorys: history)
    }
    
    func fetchUserData() -> Single<UserData> {
        return Single.create { observer in
            Task {
                do {
                    let user = try await self.coreDataManager.fetchOrCreateUser()
                    let userData = self.toEntity(user)
                    observer(.success(userData))
                } catch {
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
