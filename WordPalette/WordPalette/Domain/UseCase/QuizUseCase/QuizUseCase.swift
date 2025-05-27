//
//  QuizUseCase.swift
//  WordPalette
//
//  Created by 박주성 on 5/26/25.
//

import RxSwift

protocol QuizUseCase {
    func fetchUnsolvedWords(level: Level) -> Single<[WordEntity]>
    func fetchTodayWords() -> Single<[WordEntity]>
    func answerQuiz(word: WordEntity) -> Single<Bool>
}
