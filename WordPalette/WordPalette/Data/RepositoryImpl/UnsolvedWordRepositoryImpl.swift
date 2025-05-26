//
//  UnsolvedWordRepositoryImpl.swift
//  WordPalette
//
//  Created by iOS study on 5/21/25.
//

import Foundation
import RxSwift

final class UnsolvedWordRepositoryImpl: UnsolvedWordRepository {
    
    private let localDataSource: WordLocalDataSource
    private let coreDataManager: CoreDataManager
    
    //의존성 주입 사용 (생성자 주입)
    init(localDataSource: WordLocalDataSource, coredataManager: CoreDataManager) {
        self.localDataSource = localDataSource
        self.coreDataManager = coredataManager
    }
    
    // MARK: - Private Method
    
    // Core Data 모델 객체를 도메인 모델로 변환
    private func toEntity(_ object: UnsolvedWordObject) -> WordEntity? {
        guard let level = Level(korean: object.level) else { return nil }
        
        return WordEntity(
            id: object.id,
            word: object.word,
            meaning: object.meaning,
            example: object.example,
            level: level,
            source: .database
        )
    }

    // MARK: - 단어 검색
    
    // 로컬 데이터에서 검색어(keyword)로 단어 필터링 후 반환
    func searchWords(keyword: String, level: Level) -> Single<[WordEntity]> {
        return Single.create { single in
            // 1. 데이터소스에서 해당 레벨의 모든 단어를 불러와
            let wordItems = self.localDataSource.loadWords(level: level)
            
            // 2. keyword로 필터링 (영어/한글 모두 검색)
            let filtered = wordItems.filter { item in
                item.en.localizedCaseInsensitiveContains(keyword) ||
                item.ko.localizedCaseInsensitiveContains(keyword)
            }
            
            // 3. WordEntity로 매핑 (WordEntity와 WordItem이 달라서 변환함)
            let entities = filtered.map { item in
                WordEntity(
                    id: UUID(), /// 새로운 UUID 생성
                    word: item.en,
                    meaning: item.ko,
                    example: item.example,
                    level: level,
                    isCorrect: nil,
                    source: .json
                )
            }
            
            /// 4. 결과 반환
            single(.success(entities))
            return Disposables.create()
        }
    }
    
    // MARK: - 단어 저장
    
    // 단어장(DB)에 단어 추가
    func saveWord(word: WordEntity) -> Single<Bool> {
        Single.create { observer in
            Task {
                do {
                    try await self.coreDataManager.saveUnsolvedWord(word)
                    observer(.success(true))
                } catch {
                    observer(.success(false))
                }
            }
            
            return Disposables.create()
        }
    }
    
    // MARK: - 단어 조회
    
    // JSON에서 전체 단어 로드
    func fetchAllWords(level: Level) -> Single<[WordEntity]> {
        let items = localDataSource.loadWords(level: level)
        let entities = items.map {
            WordEntity(
                id: UUID(),
                word: $0.en,
                meaning: $0.ko,
                example: $0.example,
                level: level,
                isCorrect: nil,
                source: .json
            )
        }
        return .just(entities)
    }
    
    // 저장된 단어를 레벨 기준으로 조회 ( DB )
    func fetchWords(for level: Level) -> Single<[WordEntity]> {
        Single.create { observer in
            Task {
                do {
                    let words = try await self.coreDataManager.fetchUnsolvedWordsByLevel(level)
                    let entities = words.compactMap { self.toEntity($0) }
                    observer(.success(entities))
                } catch {
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    // MARK: - 단어 삭제
     
     /// 특정 단어 ID로 삭제
    func deleteWord(by id: UUID) -> Single<Bool> {
        Single.create { observer in
            Task {
                do {
                    try await self.coreDataManager.deleteUnsolvedWord(wordID: id)
                    observer(.success(true))
                } catch {
                    observer(.success(false))
                }
            }
            
            return Disposables.create()
        }
    }
    
    /// 전체 단어 삭제
    func deleteAllWords() -> Single<Bool> {
        Single.create { observer in
            Task {
                do {
                    try await self.coreDataManager.deleteAllUnsolvedWords()
                    observer(.success(true))
                } catch {
                    observer(.success(false))
                }
            }
            
            return Disposables.create()
        }
    }
}
