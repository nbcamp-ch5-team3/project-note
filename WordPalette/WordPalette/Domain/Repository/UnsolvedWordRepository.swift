//
//  UnsolvedWordRepository.swift
//  WordPalette
//
//  Created by 박주성 on 5/20/25.
//

import Foundation
import RxSwift

protocol UnsolvedWordRepository {
    func searchWords(keyword: String, level: Level) -> Single<[WordEntity]>
    func saveWord(word: WordEntity) -> Single<Bool>
    func fetchWords(for level: Level) -> Single<[WordEntity]>
    func deleteWord(by id: UUID) -> Single<Bool>
    func deleteAllWords() -> Single<Bool>
}
