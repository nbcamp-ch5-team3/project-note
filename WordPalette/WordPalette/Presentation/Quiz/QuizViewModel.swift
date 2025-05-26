//
//  QuizViewModel.swift
//  WordPalette
//
//  Created by 박주성 on 5/23/25.
//

import Foundation
import RxSwift
import RxRelay

final class QuizViewModel {
    
    // MARK: - State & Action
    
    enum State {
        case quizViewInfo(QuizViewInfo)
        case quizWords([WordEntity])
    }
    
    enum Action {
        case viewWillAppear
        case answer(Bool)
        case selectLevel(Level)
    }
    
    // MARK: - Properties
    
    private var unsolvedWords: [WordEntity] = []
    
    private let disposeBag = DisposeBag()
    
    let state = PublishRelay<State>()
    let action = PublishRelay<Action>()
    
    private let useCase: QuizUseCase
    
    // MARK: - Initailizer
    
    init(useCase: QuizUseCase) {
        self.useCase = useCase
        bind()
    }
    
    // MARK: - Bind
    
    private func bind() {
        action
            .subscribe(with: self) { owner, action in
                switch action {
                case .viewWillAppear:
                    self.fetchQuizViewInfo()
                case .answer(let isCorrect):
                    self.answerQuiz(isCorrect)
                case .selectLevel(let level):
                    self.fetchQuizWords(level: level)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchQuizViewInfo() {
        Single.zip(
            useCase.fetchUnsolvedWords(level: .beginner),
            useCase.fetchTodayWords()
        )
        .map { [weak self] unsolvedWords, todaySolvedWords in
            self?.unsolvedWords = unsolvedWords
            
            let correctCount = todaySolvedWords.filter { $0.isCorrect == true }.count
            let incorrectCount = todaySolvedWords.filter { $0.isCorrect == false }.count
            
            return QuizViewInfo(
                words: unsolvedWords,
                correctCount: correctCount,
                incorrectCount: incorrectCount
            )
        }
        .subscribe(with: self) { owner, quizViewInfo in
            owner.state.accept(.quizViewInfo(quizViewInfo))
        }
        .disposed(by: disposeBag)
    }
    
    private func answerQuiz(_ isCorrect: Bool) {
        guard var word = unsolvedWords.first else { return }
        word.isCorrect = isCorrect

        useCase.answerQuiz(word: word)
            .subscribe(onSuccess: { [weak self] success in
                if success {
                    print("저장 성공")
                    self?.unsolvedWords.removeFirst()
                } else {
                    print("저장 실패")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchQuizWords(level: Level) {
        useCase.fetchUnsolvedWords(level: level)
            .subscribe(with: self) { owner, words in
                owner.state.accept(.quizWords(words))
            }
            .disposed(by: disposeBag)
    }
}
