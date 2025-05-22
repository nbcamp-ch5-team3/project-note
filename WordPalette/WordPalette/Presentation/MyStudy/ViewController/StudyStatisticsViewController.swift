//
//  StudyStatisticsViewController.swift
//  WordPalette
//
//  Created by Quarang on 5/21/25.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - 날짜 별 학습 통계 UI 컨트롤러
final class StudyStatisticsViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    private let studyHistroyView = StudyStatisticsView()
    private let viewModel: StudyStatisticsViewModel
    
    override func loadView() {
        view = studyHistroyView
    }
    
    // DIContainer 추가 예정
    init(viewModel: StudyStatisticsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        configureRegister()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    /// 테이블 뷰 셀 설정
    private func configureRegister() {
        studyHistroyView.getWordTableView.register(StudyWordCell.self, forCellReuseIdentifier: StudyWordCell.identifier)
    }
    
    /// 뷰 바인딩
    private func bind() {
        let items = Observable.of(wordMocks)
        
        items
            .bind(to: studyHistroyView.getWordTableView.rx.items(
                cellIdentifier: StudyWordCell.identifier,
                cellType: StudyWordCell.self)) { row, word, cell in
                    cell.configure(word)
                }
                .disposed(by: disposeBag)
    }
}
