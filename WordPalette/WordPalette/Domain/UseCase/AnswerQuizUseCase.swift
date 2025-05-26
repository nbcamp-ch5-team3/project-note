//
//  AnswerQuizUseCase.swift
//  WordPalette
//
//  Created by 박주성 on 5/26/25.
//

import Foundation
import RxSwift

final class AnswerQuizUseCase {
    
    private let unsolvedWordRepository: UnsolvedWordRepository
    private let solvedWordRepository: SolvedWordRepository
    
    init(
        unsolvedWordRepository: UnsolvedWordRepository,
        solvedWordRepository: SolvedWordRepository
    ) {
        self.unsolvedWordRepository = unsolvedWordRepository
        self.solvedWordRepository = solvedWordRepository
    }
    
    func execute(word: WordEntity) -> Single<Bool> {
        guard let isCorrect = word.isCorrect else {
            return .just(false)
        }
        
        if isCorrect {
            // 맞힌 경우: unsolved에서 삭제 후 저장
            return unsolvedWordRepository.deleteWord(by: word.id)
                .flatMap { _ in
                    self.solvedWordRepository.saveWord(word: word)
                }
        } else {
            // 틀린 경우: 그냥 저장
            return solvedWordRepository.saveWord(word: word)
        }
    }
}
