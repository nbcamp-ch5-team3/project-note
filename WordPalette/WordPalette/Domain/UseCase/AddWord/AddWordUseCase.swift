//
//  AddWordUseCase.swift
//  WordPalette
//
//  Created by iOS study on 5/23/25.
//

import Foundation
import RxSwift

protocol AddWordUseCase {
    /// 통합된 단어 조회 (JSON + DB 합쳐서, 검색/랜덤 모두 처리)
    func fetchWords(level: Level, keyword: String?, limit: Int?) -> Single<[WordEntity]>
    
    /// 단어 저장 (JSON→DB 변환 포함)
    func saveWord(_ word: WordEntity, convertToDatabase: Bool) -> Single<WordEntity>
    
    /// 중복 체크 (전체 소스)
    func checkDuplicate(word: String) -> Single<(Bool, Level?)>
}
