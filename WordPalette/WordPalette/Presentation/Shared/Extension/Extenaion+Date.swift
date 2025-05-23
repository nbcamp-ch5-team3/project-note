//
//  Extenaion+Date.swift
//  WordPalette
//
//  Created by Quarang on 5/23/25.
//

import Foundation

// MARK: - Date 익스텐션
extension Date {
    /// Date to String
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: self)
    }
}
