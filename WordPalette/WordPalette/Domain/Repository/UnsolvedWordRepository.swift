//
//  UnsolvedWordRepository.swift
//  WordPalette
//
//  Created by iOS study on 5/21/25.
//

import Foundation
import RxSwift

protocol UnsolvedWordRepository {
    // JSON에서 전체 단어 로드
    func fetchAllWords(level: Level) -> Single<[WordEntity]>
    // DB에서 단어 로드
    func fetchWords(for level: Level) -> Single<[WordEntity]>
    
    // 검색 (JSON)
    func searchWords(keyword: String, level: Level) -> Single<[WordEntity]>
    
    // 단어 저장
    func saveWord(word: WordEntity) -> Single<Bool>

    // 삭제
    func deleteWord(by id: UUID) -> Single<Bool>

    func deleteAllWords(for level: Level) -> Single<Bool>
}
