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
    private var dateComponents: [DateComponents] = []
    
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
        configureDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.action.onNext(.viewDidAppear)
        
    }
    
    /// 델리게이트 설정
    private func configureDelegate() {
        studyHistroyView.getCalendarView.delegate = self
    }
    
    private func bind() {
        
        // 유저정보 요청 구독
        // 프로필 업데이트 및 캘린더 마킹
        viewModel.state.userData
            .subscribe(with: self) { owner, user in
                owner.dateComponents = user.studyHistorys.map { Calendar.current.dateComponents([.year, .month, .day], from: $0.solvedAt) }
                owner.studyHistroyView.getProfileSectionView.configure(TierType(value: user.score), currentScore: user.score)
                owner.studyHistroyView.getCalendarView.reloadDecorations(forDateComponents: owner.dateComponents, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
}

// MARK: - 날짜 리스트로 캘린더에 마킹
extension StudyHistoryViewController: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView,
                      decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {

        // Date 타입으로 변환
        guard let date = Calendar.current.date(from: dateComponents) else { return nil }
        let dates = self.dateComponents.compactMap { Calendar.current.date(from: $0) }
        
        // 학습한 날 여부 판단
        guard dates.contains(date) else { return nil }
        
        // 원형 dot 마커 표시
        return .image(UIImage(systemName: "pencil.tip.crop.circle.fill"), color: .customMango, size: .large)
            
    }
}
