//
//  WordLocalDataSource.swift
//  WordPalette
//
//  Created by iOS study on 5/21/25.
//

import Foundation

// MARK: - 파일과 확장자 확인한 후 JSON 파일 읽기
class WordLocalDataSource {
    func loadWords(level: Level) -> [WordItem] {
        let fileName = level.fileName
        let fileExtension = "json"
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
        print("❌\(fileName).\(fileExtension) not found❌")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let words = try JSONDecoder().decode([WordItem].self, from: data)
            return words
        } catch {
            print("❌ JSON 파일 읽기/파싱 중 에러 발생: \(error)❌")
            return []
        }
    }
}
