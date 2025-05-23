//
//  AddWordRepositoryImpl.swift
//  WordPalette
//
//  Created by iOS study on 5/23/25.
//

import RxSwift
import Foundation

final class AddWordRepositoryImpl: AddWordRepository {
    private let localDataSource: WordLocalDataSource
    private let unsolvedWordRepository: UnsolvedWordRepository
    
    init (
        localDataSource: WordLocalDataSource,
        unsolvedWordRepository: UnsolvedWordRepository
    ) {
        self.localDataSource = localDataSource
        self.unsolvedWordRepository = unsolvedWordRepository
    }
    
    // 1. 레벨별 전체 단어 로드 (json)
    func fetchAllWords(level: Level) -> Single<[WordEntity]> {
        let items = localDataSource.loadWords(level: level)
        let entities = items.map {
            WordEntity(
                id: UUID(),
                word: $0.en,
                meaning: $0.ko,
                example: $0.example,
                level: level,
                isCorrect: nil
            )
        }
        return .just(entities)
    }
    
    // 랜덤 추천 20개 (json)
    func recommendRandomWords(level: Level) -> Single<[WordEntity]> {
        let items = localDataSource.loadWords(level: level)
        let entities = items.map {
            WordEntity(
                id: UUID(),
                word: $0.en,
                meaning: $0.ko,
                example: $0.example,
                level: level,
                isCorrect: nil
            )
        }
        return .just(Array(entities.shuffled().prefix(20)))
    }
    
    // 검색 (json 기준)
    func searchWords(keyword: String, level: Level) -> Single<[WordEntity]> {
        let items = localDataSource.loadWords(level: level)
        let filtered = items.filter { item in
            item.en.localizedCaseInsensitiveContains(keyword) ||
            item.ko.localizedCaseInsensitiveContains(keyword)
        }
        let entities = filtered.map {
            WordEntity(
                id: UUID(),
                word: $0.en,
                meaning: $0.ko,
                example: $0.example,
                level: level,
                isCorrect: nil
            )
        }
        return .just(entities)
    }
    
    // 중복 체크 (json + DB)
    func checkDuplicate(word: String) -> Single<(exists: Bool, level: Level?)> {
        let levels: [Level] = [.beginner, .intermediate, .advanced]
        
        // 1. json에서 체크
        let jsonChecks = levels.map { level in
            Single<[WordEntity]>.just(
                localDataSource.loadWords(level: level).map {
                    WordEntity(
                        id: UUID(),
                        word: $0.en,
                        meaning: $0.ko,
                        example: $0.example,
                        level: level,
                        isCorrect: nil
                    )
                }
            ).map { ($0, level) }
        }
        
        return Single.zip(jsonChecks)
            .flatMap { jsonList -> Single<(exists: Bool, level: Level?)> in
                for (words, level) in jsonList {
                    if words.contains(where: { $0.word == word || $0.meaning == word }) {
                        return .just((true, level))
                    }
                }
                // 2. DB에서 체크 (UnsolvedWordRepository 활용)
                let dbChecks = levels.map { level in
                    self.unsolvedWordRepository.fetchWords(for: level).map { ($0, level) }
                }
                return Single.zip(dbChecks)
                    .map { dbList in
                        for (words, level) in dbList {
                            if words.contains(where: { $0.word == word || $0.meaning == word }) {
                                return (true, level)
                            }
                        }
                        return (false, nil)
                    }
            }
    }
    
    // DB에 저장된 단어 로드 (UnsolvedWordRepository 위임)
    func fetchDBWords(level: Level) -> Single<[WordEntity]> {
        unsolvedWordRepository.fetchWords(for: level)
    }
    
    // 단어 저장 (UnsolvedWordRepository 위임)
    func saveWord(word: WordEntity) -> Single<Bool> {
        unsolvedWordRepository.saveWord(word: word)
    }
    
}
