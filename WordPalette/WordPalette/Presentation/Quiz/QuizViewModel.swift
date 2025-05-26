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
    
    private var unsolvedWords: [WordEntity] = []
    
    private let disposeBag = DisposeBag()
    
    let state = PublishRelay<State>()
    let action = PublishRelay<Action>()
    
    private let fetchWordsUseCase: FetchUnsolvedWordsUseCase
    private let fetchTodayStudyHistoryUseCase: FetchTodayStudyHistoryUseCase
    private let answerQuizUseCase: AnswerQuizUseCase
    
    // MARK: - Initailizer
    
    init(
        fetchWordsUseCase: FetchUnsolvedWordsUseCase,
        fetchTodayStudyHistoryUseCase: FetchTodayStudyHistoryUseCase,
        answerQuizUseCase: AnswerQuizUseCase
    ) {
        self.fetchWordsUseCase = fetchWordsUseCase
        self.fetchTodayStudyHistoryUseCase = fetchTodayStudyHistoryUseCase
        self.answerQuizUseCase = answerQuizUseCase
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
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchQuizViewInfo() {
        Single.zip(
            fetchWordsUseCase.execute(for: .advanced),
            fetchTodayStudyHistoryUseCase.execute()
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
        .subscribe(onSuccess: { quizViewInfo in
            self.state.accept(.quizViewInfo(quizViewInfo))
        }, onFailure: { error in
            print("QuizViewInfo 에러 발생: \(error.localizedDescription)")
        })
        .disposed(by: disposeBag)
    }
    
    private func answerQuiz(_ isCorrect: Bool) {
        guard var word = unsolvedWords.first else { return }
        word.isCorrect = isCorrect

        answerQuizUseCase.execute(word: word)
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
}
