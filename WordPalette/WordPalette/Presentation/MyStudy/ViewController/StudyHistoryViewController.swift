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
    private let DIContainer: DIContainer
    
    private let disposeBag = DisposeBag()
    private var studyHistory: [StudyHistory] = []
    
    override func loadView() {
        view = studyHistroyView
    }
    
    // DIContainer 추가 예정
    init(viewModel: StudyHistoryViewModel, DIContainer: DIContainer) {
        self.viewModel = viewModel
        self.DIContainer = DIContainer
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
        studyHistroyView.getCalendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
    }
    
    private func bind() {
        
        // 유저정보 요청 구독
        // 프로필 업데이트 및 캘린더 마킹
        viewModel.state.userData
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(with: self) { owner, user in
                let dateComponents = user.studyHistorys.map { Calendar.current.dateComponents([.year, .month, .day], from: $0.solvedAt) }
                owner.studyHistory = user.studyHistorys
                
                owner.studyHistroyView.getProfileSectionView.configure(TierType(value: user.score), currentScore: user.score)
                owner.studyHistroyView.getCalendarView.reloadDecorations(forDateComponents: dateComponents, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
}

// MARK: - 달력 관련 Delegate
extension StudyHistoryViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    /// 날짜 리스트로 캘린더에 마킹
    func calendarView(_ calendarView: UICalendarView,
                      decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {

        // Date 타입으로 변환
        guard let date = Calendar.current.date(from: dateComponents) else { return nil }
        let isStudyDate = self.studyHistory.contains {
            Calendar.current.isDate($0.solvedAt, inSameDayAs: date)
        }
        
        guard isStudyDate else { return nil }
        
        // 원형 dot 마커 표시
        return .image(UIImage(systemName: "pencil.tip.crop.circle.fill"), color: .customMango, size: .large)
            
    }
    
    /// 학습한 날 달력 선택 시 모달 표시
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        // Date 타입으로 변환
        guard let dateComponents,
              let date = Calendar.current.date(from: dateComponents),
              let studyHistory = self.studyHistory.first(where: { Calendar.current.isDate($0.solvedAt, inSameDayAs: date) })
        else { return }
        
        // DIContainer 추가하면 바뀔 예정
        let vc = DIContainer.makeStudyStatisticsViewContoller(studyHistory: studyHistory)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
