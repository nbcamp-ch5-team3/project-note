//
//  Level+FileName.swift
//  WordPalette
//
//  Created by iOS study on 5/21/25.
//

extension Level {
    var fileName: String {
        switch self {
        case .beginner: return "beginnerWords"
        case .intermediate: return "intermediateWords"
        case .advanced: return "advancedWords"
        }
    }
}
