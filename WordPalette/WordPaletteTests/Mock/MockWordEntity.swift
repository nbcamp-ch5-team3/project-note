//
//  MockWordEntity.swift
//  WordPalette
//
//  Created by 박주성 on 5/22/25.
//

import Foundation
@testable import WordPalette

enum MockWordEntity {
    
    static let solvedWord = WordEntity(
        id: UUID(),
        word: "solve",
        meaning: "해결하다",
        example: "I solved it.",
        level: .intermediate,
        isCorrect: true
    )
    
    static let unsolvedWord = WordEntity(
        id: UUID(),
        word: "hello",
        meaning: "안녕",
        example: "hello world",
        level: .beginner,
        isCorrect: nil
    )
}
