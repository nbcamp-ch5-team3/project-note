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


// MARK: 뷰를 구성하기 위한 임시 데이터 (후반에 삭제 예정)
struct WordMock {
    let word: String        /// 영단어
    let meaning: String     /// 한글 뜻
    let level: LevelMock    /// 초급, 중급, 고급
    let isCorrect: Bool?     /// 암기 여부
}

enum LevelMock: String {
    case beginner = "초급"
    case intermediate = "중급"
    case advanced = "고급"
    
    var color: UIColor {
        switch self {
        case .beginner: .customMango
        case .intermediate: .customOrange
        case .advanced: .customStrawBerry
        }
    }
}

let wordMocks: [WordMock] = [
    WordMock(word: "apple", meaning: "사과", level: .beginner, isCorrect: true),
    WordMock(word: "banana", meaning: "바나나", level: .beginner, isCorrect: false),
    WordMock(word: "run", meaning: "달리다", level: .beginner, isCorrect: true),
    WordMock(word: "book", meaning: "책", level: .beginner, isCorrect: false),
    WordMock(word: "happy", meaning: "행복한", level: .beginner, isCorrect: true),

    WordMock(word: "compare", meaning: "비교하다", level: .intermediate, isCorrect: true),
    WordMock(word: "increase", meaning: "증가하다", level: .intermediate, isCorrect: false),
    WordMock(word: "danger", meaning: "위험", level: .intermediate, isCorrect: true),
    WordMock(word: "culture", meaning: "문화", level: .intermediate, isCorrect: false),
    WordMock(word: "responsible", meaning: "책임 있는", level: .intermediate, isCorrect: true),

    WordMock(word: "abandon", meaning: "버리다", level: .advanced, isCorrect: false),
    WordMock(word: "contemplate", meaning: "심사숙고하다", level: .advanced, isCorrect: true),
    WordMock(word: "inevitable", meaning: "불가피한", level: .advanced, isCorrect: false),
    WordMock(word: "sophisticated", meaning: "세련된", level: .advanced, isCorrect: true),
    WordMock(word: "notorious", meaning: "악명 높은", level: .advanced, isCorrect: false),

    WordMock(word: "smile", meaning: "미소 짓다", level: .beginner, isCorrect: true),
    WordMock(word: "travel", meaning: "여행하다", level: .intermediate, isCorrect: false),
    WordMock(word: "justice", meaning: "정의", level: .advanced, isCorrect: true),
    WordMock(word: "solution", meaning: "해결책", level: .intermediate, isCorrect: true),
    WordMock(word: "brilliant", meaning: "훌륭한", level: .advanced, isCorrect: true)
]


