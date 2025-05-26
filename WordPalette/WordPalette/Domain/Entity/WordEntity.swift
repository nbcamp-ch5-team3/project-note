//
//  WordEntity.swift
//  WordPalette
//
//  Created by iOS study on 5/21/25.
//

import Foundation

enum WordSource: Int16 {
    case json = 0
    case database = 1
}
struct WordEntity {
    let id: UUID
    let word: String
    let meaning: String
    var example: String
    let level: Level
    var isCorrect: Bool?
    let source: WordSource
}
