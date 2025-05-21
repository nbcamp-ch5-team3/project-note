//
//  StudyHistoryViewController.swift
//  WordPalette
//
//  Created by Quarang on 5/21/25.
//

import UIKit

// MARK: - 나의 학습기록 UI 컨트롤러
final class StudyHistoryViewController: UIViewController {
    
    private let studyHistroyView = StudyHistoryView()
    private let viewModel: StudyHistoryViewModel
    
    override func loadView() {
        view = studyHistroyView
    }
    
    init(viewModel: StudyHistoryViewModel) {
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
