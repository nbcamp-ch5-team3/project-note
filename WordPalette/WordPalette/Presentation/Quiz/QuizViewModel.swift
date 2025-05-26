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
    }
    
    enum Action {
        case viewWillAppear
        case answer(Bool)
    }
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    let state = PublishRelay<State>()
    let action = PublishRelay<Action>()
    
    private let fetchWordsUseCase: FetchUnsolvedWordsUseCase
    private let fetchTodayStudyHistoryUseCase: FetchTodayStudyHistoryUseCase
    
    // MARK: - Initailizer
    
    init(
        fetchWordsUseCase: FetchUnsolvedWordsUseCase,
        fetchTodayStudyHistoryUseCase: FetchTodayStudyHistoryUseCase,
    ) {
        self.fetchWordsUseCase = fetchWordsUseCase
        self.fetchTodayStudyHistoryUseCase = fetchTodayStudyHistoryUseCase
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
                    print(isCorrect)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchQuizViewInfo() {
        Observable.zip(
            fetchWordsUseCase.execute(for: .advanced),
            fetchTodayStudyHistoryUseCase.execute()
        )
        .map { unsolvedWords, todaySolvedWords in
            let correctCount = todaySolvedWords.filter { $0.isCorrect == true }.count
            let incorrectCount = todaySolvedWords.filter { $0.isCorrect == false }.count
            
            let quizViewInfo = QuizViewInfo(
                words: unsolvedWords,
                correctCount: correctCount,
                incorrectCount: incorrectCount
            )
            
            return State.quizViewInfo(quizViewInfo)
        }
        .bind(to: state)
        .disposed(by: disposeBag)
    }
}
