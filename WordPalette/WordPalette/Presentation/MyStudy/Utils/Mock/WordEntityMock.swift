//
//  WordEntityMock.swift
//  WordPalette
//
//  Created by Quarang on 5/22/25.
//

import Foundation

let wordMocks: [WordEntity] = [
    WordEntity(id: UUID(), word: "apple", meaning: "사과", example: "I ate an apple.", level: .beginner, isCorrect: true, source: .database),
    WordEntity(id: UUID(), word: "banana", meaning: "바나나", example: "Bananas are yellow.", level: .beginner, isCorrect: false, source: .database),
    WordEntity(id: UUID(), word: "run", meaning: "달리다", example: "She can run fast.", level: .beginner, isCorrect: true, source: .database),
    WordEntity(id: UUID(), word: "book", meaning: "책", example: "This book is interesting.", level: .beginner, isCorrect: false, source: .database),
    WordEntity(id: UUID(), word: "happy", meaning: "행복한", example: "He looks happy today.", level: .beginner, isCorrect: true, source: .database),

    WordEntity(id: UUID(), word: "compare", meaning: "비교하다", example: "Let’s compare the two results.", level: .intermediate, isCorrect: true, source: .database),
    WordEntity(id: UUID(), word: "increase", meaning: "증가하다", example: "Sales increased last month.", level: .intermediate, isCorrect: false, source: .database),
    WordEntity(id: UUID(), word: "danger", meaning: "위험", example: "There’s a danger of falling.", level: .intermediate, isCorrect: true, source: .database),
    WordEntity(id: UUID(), word: "culture", meaning: "문화", example: "Korean culture is unique.", level: .intermediate, isCorrect: false, source: .database),
    WordEntity(id: UUID(), word: "responsible", meaning: "책임 있는", example: "She is responsible for the project.", level: .intermediate, isCorrect: true, source: .database),

    WordEntity(id: UUID(), word: "abandon", meaning: "버리다", example: "He had to abandon the plan.", level: .advanced, isCorrect: false, source: .database),
    WordEntity(id: UUID(), word: "contemplate", meaning: "심사숙고하다", example: "They contemplated their next move.", level: .advanced, isCorrect: true, source: .database),
    WordEntity(id: UUID(), word: "inevitable", meaning: "불가피한", example: "Failure was inevitable.", level: .advanced, isCorrect: false, source: .database),
    WordEntity(id: UUID(), word: "sophisticated", meaning: "세련된", example: "She has a sophisticated style.", level: .advanced, isCorrect: true, source: .database),
    WordEntity(id: UUID(), word: "notorious", meaning: "악명 높은", example: "The area is notorious for crime.", level: .advanced, isCorrect: false, source: .database),

    WordEntity(id: UUID(), word: "smile", meaning: "미소 짓다", example: "She smiled at me.", level: .beginner, isCorrect: true, source: .database),
    WordEntity(id: UUID(), word: "travel", meaning: "여행하다", example: "I love to travel abroad.", level: .intermediate, isCorrect: false, source: .database),
    WordEntity(id: UUID(), word: "justice", meaning: "정의", example: "They fought for justice.", level: .advanced, isCorrect: true, source: .database),
    WordEntity(id: UUID(), word: "solution", meaning: "해결책", example: "We found a solution.", level: .intermediate, isCorrect: true, source: .database),
    WordEntity(id: UUID(), word: "brilliant", meaning: "훌륭한", example: "That’s a brilliant idea.", level: .advanced, isCorrect: true, source: .database)
]
