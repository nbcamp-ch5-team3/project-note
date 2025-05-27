//
//  QuizUseCaseImpl.swift
//  WordPalette
//
//  Created by 박주성 on 5/26/25.
//

import RxSwift

final class QuizUseCaseImpl: QuizUseCase {
    
    private let unsolvedWordRepository: UnsolvedWordRepository
    private let solvedWordRepository: SolvedWordRepository
    
    init(
        unsolvedWordRepository: UnsolvedWordRepository,
        solvedWordRepository: SolvedWordRepository
    ) {
        self.unsolvedWordRepository = unsolvedWordRepository
        self.solvedWordRepository = solvedWordRepository
    }

    func fetchUnsolvedWords(level: Level) -> Single<[WordEntity]> {
        unsolvedWordRepository.fetchWords(for: level)
    }
    
    func fetchTodayWords() -> Single<[WordEntity]> {
        solvedWordRepository.fetchTodayWords()
    }
    
    func answerQuiz(word: WordEntity) -> Single<Bool> {
        return unsolvedWordRepository.deleteWord(by: word.id)
            .flatMap { isDeleted in
                if isDeleted {
                    self.solvedWordRepository.saveWord(word: word)
                } else {
                    Single.just(false)
                }
            }
    }
}
