//
//  QuizViewController.swift
//  WordPalette
//
//  Created by 박주성 on 5/22/25.
//

import UIKit
import RxSwift
import RxCocoa

final class QuizViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: QuizViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let quizView = QuizView()
    
    // MARK: - Initailizer
    
    init(viewModel: QuizViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = quizView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.action.accept(.viewWillAppear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        quizView.updateLevelButtons(with: .beginner)
    }
}

// MARK: - Configure

private extension QuizViewController {
    func setBindings() {
        viewModel.state
            .asSignal()
            .emit(with: self) { owner, state in
                switch state {
                case .quizViewInfo(let quizViewInfo):
                    owner.quizView.update(with: quizViewInfo)
                }
            }
            .disposed(by: disposeBag)
        
        quizView.action
            .bind(with: self) { owner, action in
                switch action {
                case .didSwipe(let isCorrect):
                    owner.viewModel.action.accept(.answer(isCorrect))
                    owner.quizView.updateAfterAnswer(with: isCorrect)
                case .didFinishQuiz:
                    break
                case .didSelectLevel(let level):
                    owner.viewModel.action.accept(.selectLevel(level))
                    owner.quizView.updateLevelButtons(with: level)
                }
            }
            .disposed(by: disposeBag)
    }
}
