//
//  StudyHistoryViewController.swift
//  WordPalette
//
//  Created by Quarang on 5/21/25.
//

import UIKit
import RxSwift

// MARK: - 나의 학습기록 UI 컨트롤러
final class StudyHistoryViewController: UIViewController {
    
    private let studyHistroyView = StudyHistoryView()
    private let viewModel: StudyHistoryViewModel
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = studyHistroyView
    }
    
    // DIContainer 추가 예정
    init(viewModel: StudyHistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.action.onNext(.viewDidAppear)
        
    }
    
    private func bind() {
        
        viewModel.state.userData
            .subscribe(with: self) { owner, user in
                owner.studyHistroyView.getProfileSectionView.configure(TierType(value: user.score), currentScore: user.score)
            }
            .disposed(by: disposeBag)
        
        
    }
}
