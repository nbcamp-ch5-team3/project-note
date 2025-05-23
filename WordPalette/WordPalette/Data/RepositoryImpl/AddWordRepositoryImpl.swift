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
    
    // 랜덤 추천 20개 (json+DB)
    func recommendRandomWords(level: Level) -> Single<[WordEntity]> {
        return fetchAllWordsMerged(level: level)
            .map { allWords in
                Array(allWords.shuffled().prefix(20))
            }
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
        let searchWord = word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
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
                // 대소문자 무시하고 단어 매칭
                for (words, level) in jsonList {
                    if words.contains(where: {
                        $0.word.lowercased() == searchWord ||
                        $0.meaning.lowercased() == searchWord
                    }) {
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
                            if words.contains(where: {
                                $0.word.lowercased() == searchWord ||
                                $0.meaning.lowercased() == searchWord
                            }) {
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
    
    // JSON+DB 반환
    func fetchAllWordsMerged(level: Level) -> Single<[WordEntity]> {
        Single.zip(
            fetchAllWords(level: level), // JSON
            fetchDBWords(level: level)   // DB
        )
        .map { jsonWords, dbWords in
            // 중복 제거 (영어단어 기준)
            let allWords = (jsonWords + dbWords)
            var seen = Set<String>()
            return allWords.filter { seen.insert($0.word.lowercased()).inserted }
        }
    }
    
    // JSON+DB 반환 (검색용)
    func searchWordsMerged(keyword: String, level: Level) -> Single<[WordEntity]> {
        Single.zip(
            searchWords(keyword: keyword, level: level), // JSON
            fetchDBWords(level: level).map { dbWords in
                dbWords.filter {
                    $0.word.localizedCaseInsensitiveContains(keyword) ||
                    $0.meaning.localizedCaseInsensitiveContains(keyword)
                }
            }
        )
        .map { jsonWords, dbWords in
            let allWords = (jsonWords + dbWords)
            var seen = Set<String>()
            return allWords.filter { seen.insert($0.word.lowercased()).inserted }
        }
    }
}
