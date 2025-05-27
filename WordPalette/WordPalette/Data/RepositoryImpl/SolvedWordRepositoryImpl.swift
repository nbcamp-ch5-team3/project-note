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
    
    // MARK: - Private Method
    
    /// Core Data 모델 객체를 도메인 모델로 변환    
    private func toEntity(_ object: SolvedWordObject) -> WordEntity? {
        guard let level = Level(korean: object.level) else { return nil }
        
        return WordEntity(
            id: object.id,
            word: object.word,
            meaning: object.meaning,
            example: object.example,
            level: level,
            isCorrect: object.isCorrect,
            source: .database
        )
    }
    
    // MARK: - 단어 저장
    
    /// 푼 문제 저장
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
    
    // MARK: - 단어 조회
    
    /// StudyHistory ID로 해당 일자의 푼 문제 불러오기
    func fetchWords(id: UUID) -> Single<[WordEntity]> {
        return Single.create { observer in
            Task {
                do {
                    let words = try await self.coreDataManager.fetchSolvedWords(for: id)
                    let entities = words.compactMap { self.toEntity($0) }
                    observer(.success(entities))
                } catch {
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func fetchTodayWords() -> Single<[WordEntity]> {
        return Single.create { observer in
            Task {
                do {
                    let words = try await self.coreDataManager.fetchTodaySolvedWords()
                    let entities = words.compactMap { self.toEntity($0) }
                    observer(.success(entities))
                } catch {
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
}
