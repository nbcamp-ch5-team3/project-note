//
//  UnsolvedWordRepository.swift
//  WordPalette
//
//  Created by iOS study on 5/21/25.
//

import Foundation
import RxSwift

protocol UnsolvedWordRepository {
    func searchWord(keyword: String, level: Level) -> Single<[WordEntity]>
    func saveWord(word: WordEntity) -> Single<Bool>
    func fetchWords(for level: Level) -> Single<[WordEntity]>
    func deleteWord(by id: UUID) -> Single<Bool>
    func deleteAllWords() -> Single<Bool>
}
