//
//  SolvedWordRepositoryImpl 2.swift
//  WordPalette
//
//  Created by 박주성 on 5/21/25.
//

import Foundation
import RxSwift

final class SolvedWordRepositoryImpl: SolvedWordRepository {
    
    private let coreDataManager: CoreDataManager
    
    init(coredataManager: CoreDataManager) {
        self.coreDataManager = coredataManager
    }
    
    private func toEntity(_ object: SolvedWordObject) -> WordEntity {
        return WordEntity(
            id: object.id,
            word: object.word,
            meaning: object.meaning,
            example: object.example,
            level: .init(korean: object.level) ?? .advanced,
            iscorrect: object.isCorrect
        )
    }
    
    /// 푼 문제 저장하기
    func saveWord(word: WordEntity) -> Single<Bool> {
        return Single.create { observer in
            Task {
                do {
                    try await self.coreDataManager.saveSolvedWord(word)
                    observer(.success(true))
                } catch {
                    observer(.success(false))
                }
            }
            return Disposables.create()
        }
    }
    
    /// StudyHistoryID를 통해 해당 일자 푼 문제 불러오기
    func fetchWords(id: UUID) -> Single<[WordEntity]> {
        return Single.create { observer in
            Task {
                do {
                    let words = try await self.coreDataManager.fetchSolvedWords(for: id)
                    let entities = words.map { self.toEntity($0) }
                    observer(.success(entities))
                } catch {
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
