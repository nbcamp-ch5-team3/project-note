//
//  MockWordLocalDataSource.swift
//  WordPalette
//
//  Created by 박주성 on 5/22/25.
//

import Foundation
@testable import WordPalette

final class MockWordLocalDataSource: WordLocalDataSource {
    
    // 테스트용 더미 데이터
    private let dummyWords: [WordItem] = [
        WordItem(id: 1, en: "hello", ko: "안녕", example: "hello world"),
        WordItem(id: 2, en: "solve", ko: "해결하다", example: "I solved it."),
        WordItem(id: 3, en: "apple", ko: "사과", example: "I like apple")
    ]
    
    override func loadWords(level: Level) -> [WordItem] {
        return dummyWords
    }
}
