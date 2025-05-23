//
//  AddWordUseCaseImpl.swift
//  WordPalette
//
//  Created by iOS study on 5/23/25.
//

import Foundation
import RxSwift

final class AddWordUseCaseImpl: AddWordUseCase {
    private let repository: AddWordRepository
    
    init(repository: AddWordRepository) {
        self.repository = repository
    }
    func fetchAllWords(level: Level) -> Single<[WordEntity]> {
        repository.fetchAllWords(level: level)
    }
    func fetchDBWords(level: Level) -> Single<[WordEntity]> {
        repository.fetchDBWords(level: level)
    }
    func recommendRandomWords(level: Level) -> Single<[WordEntity]> {
        repository.recommendRandomWords(level: level)
    }
    func searchWords(keyword: String, level: Level) -> Single<[WordEntity]> {
        repository.searchWords(keyword: keyword, level: level)
    }
    func saveWord(word: WordEntity) -> Single<Bool> {
        repository.saveWord(word: word)
    }
    func checkDuplicate(word: String) -> Single<(exists: Bool, level: Level?)> {
        repository.checkDuplicate(word: word)
    }
}
