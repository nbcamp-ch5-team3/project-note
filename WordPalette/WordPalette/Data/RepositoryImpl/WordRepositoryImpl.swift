//
//  WordRepositoryImpl.swift
//  WordPalette
//
//  Created by iOS study on 5/21/25.
//

import RxSwift
import Foundation

// MARK: - 로컬 데이터에서 단어를 검색어(keyword)로 필터링해서 반환
final class WordRepositoryImpl: WordRepository {
    private let localDataSource: WordLocalDataSource
    
    ///의존성 주입 사용 (생성자 주입)
    init(localDataSource: WordLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func searchWord(keyword: String, level: Level) -> Single<[WordEntity]> {
        return Single.create { single in
            /// 1. 데이터소스에서 해당 레벨의 모든 단어를 불러와
            let wordItems = self.localDataSource.loadWords(level: level)
            
            /// 2. keyword로 필터링 (영어/한글 모두 검색)
            let filtered = wordItems.filter { item in
                item.en.localizedCaseInsensitiveContains(keyword) ||
                item.ko.localizedCaseInsensitiveContains(keyword)
            }
            
            /// 3. WordEntity로 매핑 (WordEntity와 WordItem이 달라서 변환함)
            let entities = filtered.map { item in
                WordEntity(
                    id: UUID(), /// 새로운 UUID 생성
                    word: item.en,
                    meaning: item.ko,
                    example: item.example,
                    level: level,
                    isCorrect: nil
                )
            }
            
            /// 4. 결과 반환
            single(.success(entities))
            return Disposables.create()
        }
    }
}
