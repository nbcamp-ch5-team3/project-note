//
//  AddWordUseCase.swift
//  WordPalette
//
//  Created by iOS study on 5/23/25.
//

import Foundation
import RxSwift

protocol AddWordUseCase {
    // 레벨별 전체 단어 로드 (json)
    func fetchAllWords(level: Level) -> Single<[WordEntity]>
    
    // 랜덤 추천 20개
    func recommendRandomWords(level: Level) -> Single<[WordEntity]>
    
    // json+DB (refresh-저장 중복 확인용, 검색용)
    func fetchAllWordsMerged(level: Level) -> Single<[WordEntity]>
    func searchWordsMerged(keyword: String, level: Level) -> Single<[WordEntity]>

    // 단어 저장
    func saveWord(word: WordEntity) -> Single<Bool>
    
    // 중복 체크 (json + DB)
    func checkDuplicate(word: String) -> Single<(exists: Bool, level: Level?)>
}
