//
//  AddWordRepository.swift
//  WordPalette
//
//  Created by iOS study on 5/23/25.
//

import Foundation
import RxSwift

protocol AddWordRepository {
    // 레벨별 전체 단어 로드 (json)
    func fetchAllWords(level: Level) -> Single<[WordEntity]>
    
    // 랜덤 추천 20개 (json)
    func recommendRandomWords(level: Level) -> Single<[WordEntity]>
    
    // 검색 (json 기준)
    func searchWords(keyword: String, level: Level) -> Single<[WordEntity]>
    
    // 중복 체크 (json + DB)
    func checkDuplicate(word: String) -> Single<(exists: Bool, level: Level?)>
    
    // DB 관련 메서드는 내부적으로 UnsolvedWordRepository 사용
    func fetchDBWords(level: Level) -> Single<[WordEntity]>
    func saveWord(word: WordEntity) -> Single<Bool>
    
    // 검색 (json+DB)
    func fetchAllWordsMerged(level: Level) -> Single<[WordEntity]>
    func searchWordsMerged(keyword: String, level: Level) -> Single<[WordEntity]>
}
