//
//  AddWordUseCaseImpl.swift
//  WordPalette
//
//  Created by iOS study on 5/23/25.
//

import Foundation
import RxSwift

final class AddWordUseCaseImpl: AddWordUseCase {
    private let repository: UnsolvedWordRepository
    
    init(repository: UnsolvedWordRepository) {
        self.repository = repository
    }
//    
//    // JSON 전체 단어
//    func fetchAllWords(level: Level) -> Single<[WordEntity]> {
//        repository.fetchAllWords(level: level)
//    }
//    
//    // 랜덤 추천 20개 (json+DB 합치기)
//    func recommendRandomWords(level: Level) -> Single<[WordEntity]> {
//        fetchAllWordsMerged(level: level)
//            .map { Array($0.shuffled().prefix(20)) }
//    }
//    
//    // json+DB 합치기 (refresh, 저장 중복 확인용)
//    func fetchAllWordsMerged(level: Level) -> Single<[WordEntity]> {
//        Single.zip(
//            repository.fetchAllWords(level: level),
//            repository.fetchWords(for: level)
//        )
//        .map { jsonWords, dbWords in
//            let dbWordSet = Set(dbWords.map { $0.word.lowercased() })
//            let jsonEntities = jsonWords.filter { !dbWordSet.contains($0.word.lowercased()) }
//            return dbWords + jsonEntities // DB 우선, 그 다음 JSON
//        }
//    }
//    
//    // json+DB 합치기 (검색용)
//    func searchWordsMerged(keyword: String, level: Level) -> Single<[WordEntity]> {
//        Single.zip(
//            repository.searchWords(keyword: keyword, level: level),
//            repository.fetchWords(for: level).map { dbWords in
//                dbWords.filter {
//                    $0.word.localizedCaseInsensitiveContains(keyword) ||
//                    $0.meaning.localizedCaseInsensitiveContains(keyword)
//                }
//            }
//        )
//        // DB에 이미 있는 단어는 jsonWords에서 빼고, DB 단어 먼저 보여주기
//        .map { jsonWords, dbWords in
//            let dbWordSet = Set(dbWords.map { $0.word.lowercased() })
//            let filteredJsonWords = jsonWords.filter { !dbWordSet.contains($0.word.lowercased()) }
//            return dbWords + filteredJsonWords
//        }
//    }
//    
//    // 중복 체크 (json+DB)
//    func checkDuplicate(word: String) -> Single<(exists: Bool, level: Level?)> {
//        let levels: [Level] = [.beginner, .intermediate, .advanced]
//        let searchWord = word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
//        
//        // 1. json에서 체크
//        let jsonChecks = levels.map { level in
//            repository.fetchAllWords(level: level)
//                .map { ($0, level) }
//        }
//        return Single.zip(jsonChecks)
//            .flatMap { jsonList -> Single<(exists: Bool, level: Level?)> in
//                for (words, level) in jsonList {
//                    if words.contains(where: {
//                        $0.word.lowercased() == searchWord ||
//                        $0.meaning.lowercased() == searchWord
//                    }) {
//                        return .just((true, level))
//                    }
//                }
//                // 2. DB에서 체크
//                let dbChecks = levels.map { level in
//                    self.repository.fetchWords(for: level).map { ($0, level) }
//                }
//                return Single.zip(dbChecks)
//                    .map { dbList in
//                        for (words, level) in dbList {
//                            if words.contains(where: {
//                                $0.word.lowercased() == searchWord ||
//                                $0.meaning.lowercased() == searchWord
//                            }) {
//                                return (true, level)
//                            }
//                        }
//                        return (false, nil)
//                    }
//            }
//    }
//    
//    // 중복체크 (DB)
//    func checkDuplicateInDB(word: String) -> Single<Bool> {
//        let levels: [Level] = [.beginner, .intermediate, .advanced]
//        let searchWord = word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
//        let dbChecks = levels.map { level in
//            repository.fetchWords(for: level)
//        }
//        return Single.zip(dbChecks)
//            .map { dbLists in
//                let allWords = dbLists.flatMap { $0 }
//                return allWords.contains { $0.word.lowercased() == searchWord }
//            }
//    }
//    
//    // source를 database로 변경
//    func saveWordToDatabase(word: WordEntity) -> Single<Bool> {
//        let dbWord = WordEntity(
//            id: UUID(),
//            word: word.word,
//            meaning: word.meaning,
//            example: word.example,
//            level: word.level,
//            isCorrect: nil,
//            source: .database
//        )
//        return repository.saveWord(word: dbWord)
//        
//    }
//    
//    // 저장
//    func saveWord(word: WordEntity) -> Single<Bool> {
//        repository.saveWord(word: word)
//    }
    
    // =======================================================
    
    func fetchWords(level: Level, keyword: String? = nil, limit: Int? = nil) -> Single<[WordEntity]> {
        let jsonWords: Single<[WordEntity]>
        
        if let keyword = keyword, !keyword.isEmpty {
            // 검색 모드
            jsonWords = repository.searchWords(keyword: keyword, level: level)
        } else {
            // 전체 조회 모드
            jsonWords = repository.fetchAllWords(level: level)
        }
        
        return Single.zip(jsonWords, repository.fetchWords(for: level))
            .map { jsonEntities, dbEntities in
                // DB 단어 우선 + JSON에서 중복 제거
                let dbWordSet = Set(dbEntities.map { $0.word.lowercased() })
                let filteredJsonWords = jsonEntities.filter { !dbWordSet.contains($0.word.lowercased()) }
                
                var result = dbEntities + filteredJsonWords
                
                // 검색 모드에서는 DB도 필터링
                if let keyword = keyword, !keyword.isEmpty {
                    let dbFiltered = dbEntities.filter {
                        $0.word.localizedCaseInsensitiveContains(keyword) ||
                        $0.meaning.localizedCaseInsensitiveContains(keyword)
                    }
                    result = dbFiltered + filteredJsonWords
                }
                
                // 랜덤 셔플 및 제한
                if let limit = limit {
                    result = Array(result.shuffled().prefix(limit))
                }
                
                return result
            }
    }
    
    /// 단어 저장 - JSON→DB 변환 로직 통합
    func saveWord(_ word: WordEntity, convertToDatabase: Bool = false) -> Single<WordEntity> {
        let wordToSave: WordEntity
        
        if convertToDatabase && word.source == .json {
            // JSON → DB 변환
            wordToSave = WordEntity(
                id: UUID(),
                word: word.word,
                meaning: word.meaning,
                example: word.example,
                level: word.level,
                isCorrect: nil,
                source: .database
            )
        } else {
            wordToSave = word
        }
        
        return repository.saveWord(word: wordToSave)
            .map { success in
                guard success else {
                    throw NSError(domain: "SaveError", code: -1, userInfo: nil)
                }
                return wordToSave
            }
    }
    
    // 중복 체크 (Json + DB 체크)
    func checkDuplicate(word: String) -> Single<(Bool, Level?)> {
        let levels: [Level] = [.beginner, .intermediate, .advanced]
        let searchWord = word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 1. JSON에서 체크
        let jsonChecks = levels.map { level in
            repository.fetchAllWords(level: level).map { ($0, level) }
        }
        
        return Single.zip(jsonChecks)
            .flatMap { jsonResults -> Single<(Bool, Level?)> in
                // JSON에서 중복 찾기
                for (words, level) in jsonResults {
                    if words.contains(where: { $0.word.lowercased() == searchWord }) {
                        return .just((true, level))
                    }
                }
                
                // 2. DB에서 체크
                let dbChecks = levels.map { level in
                    self.repository.fetchWords(for: level).map { ($0, level) }
                }
                
                return Single.zip(dbChecks)
                    .map { dbResults in
                        for (words, level) in dbResults {
                            if words.contains(where: { $0.word.lowercased() == searchWord }) {
                                return (true, level)
                            }
                        }
                        return (false, nil)
                    }
            }
    }
}
