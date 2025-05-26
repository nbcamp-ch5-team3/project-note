//
//  AnswerQuizUseCase.swift
//  WordPalette
//
//  Created by 박주성 on 5/26/25.
//

import Foundation
import RxSwift

final class AnswerQuizUseCase {
    
    private let repository: SolvedWordRepository
    
    init(repository: SolvedWordRepository) {
        self.repository = repository
    }
    
    func execute(word: WordEntity) -> Single<Bool> {
        repository.saveWord(word: word)
    }
}
