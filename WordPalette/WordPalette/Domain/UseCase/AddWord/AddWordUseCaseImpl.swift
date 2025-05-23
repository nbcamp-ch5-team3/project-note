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
    
    // JSON 전체 단어
    func fetchAllWords(level: Level) -> Single<[WordEntity]> {
        repository.fetchAllWords(level: level)
    }
    
    // 랜덤 추천 20개 (json+DB 합치기)
    func recommendRandomWords(level: Level) -> Single<[WordEntity]> {
        fetchAllWordsMerged(level: level)
            .map { Array($0.shuffled().prefix(20)) }
    }
    
    // json+DB 합치기 (refresh, 저장 중복 확인용)
    func fetchAllWordsMerged(level: Level) -> Single<[WordEntity]> {
        Single.zip(
            repository.fetchAllWords(level: level),
            repository.fetchWords(for: level)
        )
        .map { jsonWords, dbWords in
            let allWords = (jsonWords + dbWords)
            var seen = Set<String>()
            return allWords.filter { seen.insert($0.word.lowercased()).inserted }
        }
    }
    
    // json+DB 합치기 (검색용)
    func searchWordsMerged(keyword: String, level: Level) -> Single<[WordEntity]> {
        Single.zip(
            repository.searchWords(keyword: keyword, level: level),
            repository.fetchWords(for: level).map { dbWords in
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
    
    // 중복 체크 (json+DB)
    func checkDuplicate(word: String) -> Single<(exists: Bool, level: Level?)> {
        let levels: [Level] = [.beginner, .intermediate, .advanced]
        let searchWord = word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 1. json에서 체크
        let jsonChecks = levels.map { level in
            repository.fetchAllWords(level: level)
                .map { ($0, level) }
        }
        return Single.zip(jsonChecks)
            .flatMap { jsonList -> Single<(exists: Bool, level: Level?)> in
                for (words, level) in jsonList {
                    if words.contains(where: {
                        $0.word.lowercased() == searchWord ||
                        $0.meaning.lowercased() == searchWord
                    }) {
                        return .just((true, level))
                    }
                }
                // 2. DB에서 체크
                let dbChecks = levels.map { level in
                    self.repository.fetchWords(for: level).map { ($0, level) }
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
    
    // 저장
    func saveWord(word: WordEntity) -> Single<Bool> {
        repository.saveWord(word: word)
    }
}
