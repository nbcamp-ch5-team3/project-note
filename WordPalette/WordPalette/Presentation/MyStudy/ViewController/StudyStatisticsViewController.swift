//
//  StudyStatisticsViewController.swift
//  WordPalette
//
//  Created by Quarang on 5/21/25.
//

import UIKit

// MARK: - 날짜 별 학습 통계 UI 컨트롤러
final class StudyStatisticsViewController: UIViewController {
    
    private let studyHistroyView = StudyStatisticsView()
    private let viewModel: StudyStatisticsViewModel
    
    override func loadView() {
        view = studyHistroyView
    }
    
    // DIContainer 추가 예정
    init(viewModel: StudyStatisticsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
