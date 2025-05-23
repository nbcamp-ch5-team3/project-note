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
    
    // DB에 저장된 단어 로드
    func fetchDBWords(level: Level) -> Single<[WordEntity]>
    
    // 랜덤 추천 20개
    func recommendRandomWords(level: Level) -> Single<[WordEntity]>
    
    // 검색 (json 기준)
    func searchWords(keyword: String, level: Level) -> Single<[WordEntity]>
    
    // 단어 저장
    func saveWord(word: WordEntity) -> Single<Bool>
    
    // 중복 체크 (json + DB)
    func checkDuplicate(word: String) -> Single<(exists: Bool, level: Level?)>
}
