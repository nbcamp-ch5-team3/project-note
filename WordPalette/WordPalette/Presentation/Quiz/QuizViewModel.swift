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
    
    private let mockData = [
        WordEntity(
            id: UUID(),
            word: "hello",
            meaning: "안녕",
            example: "hello world",
            level: .beginner,
            isCorrect: nil
        ),WordEntity(
            id: UUID(),
            word: "hello",
            meaning: "안녕",
            example: "hello world",
            level: .beginner,
            isCorrect: nil
        )
        ,WordEntity(
            id: UUID(),
            word: "hello",
            meaning: "안녕",
            example: "hello world",
            level: .beginner,
            isCorrect: nil
        )
    ]
    
    // MARK: - State & Action
    
    enum State {
        case quizViewInfo(QuizViewInfo)
    }
    
    enum Action {
        case viewWillAppear
    }
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    let state = PublishRelay<State>()
    let action = PublishRelay<Action>()
    
    
    // MARK: - Initailizer
    
    init() {
        bind()
    }
    
    // MARK: - Bind
    
    private func bind() {
        action
            .subscribe(with: self) { owner, action in
                switch action {
                case .viewWillAppear:
                    let quizViewInfo = QuizViewInfo(words: owner.mockData, correctCount: 2, incorrectCount: 5)
                    owner.state.accept(.quizViewInfo(quizViewInfo))
                }
            }
            .disposed(by: disposeBag)
    }
    
}
