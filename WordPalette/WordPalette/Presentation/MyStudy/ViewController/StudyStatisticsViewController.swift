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
    
    private let studyHistory: StudyHistory
    private let viewModel: StudyStatisticsViewModel
    
    override func loadView() {
        view = studyHistroyView
    }
    
    // DIContainer 추가 예정
    init(studyHistory: StudyHistory, viewModel: StudyStatisticsViewModel) {
        self.studyHistory = studyHistory
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRegister()
        bind()
    }
    
    /// 테이블 뷰 셀 설정
    private func configureRegister() {
        studyHistroyView.getWordTableView.register(StudyWordCell.self, forCellReuseIdentifier: StudyWordCell.identifier)
    }
    
    /// 뷰 바인딩
    private func bind() {
        // MARK: - 구독
        
        // 닫기 버튼 바인딩
        studyHistroyView.getDismissButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 단어 리스트 바인딩
        viewModel.state.statisticData
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: studyHistroyView.getWordTableView.rx.items(
                cellIdentifier: StudyWordCell.identifier,
                cellType: StudyWordCell.self)) { _, word, cell in
                    cell.configure(word)
                }
                .disposed(by: disposeBag)
        
        // 암기/미암기 수량
        viewModel.state.memoStateData
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, data in
                let (memo, unMemo) = data
                owner.studyHistroyView.configure(date: owner.studyHistory.solvedAt, memo: memo, unMemo: unMemo)
            }
            .disposed(by: disposeBag)
        
        // MARK: - 방출
        
        // viewDidLoad 시 이벤트 emit
        viewModel.action.onNext(.viewDidLoad(id: studyHistory.id))
        
        // 세그먼트 컨트롤 변경 시 이벤트 emit
        studyHistroyView.getSegmentControl
            .rx.selectedSegmentIndex
            .bind(with: self) { owner, index in
                owner.viewModel.action.onNext(.didChangedSegmentIndex(index: index))
            }
            .disposed(by: disposeBag)
    }
}
