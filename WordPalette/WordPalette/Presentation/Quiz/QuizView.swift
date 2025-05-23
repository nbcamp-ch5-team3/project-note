//
//  QuizView.swift
//  WordPalette
//
//  Created by 박주성 on 5/22/25.
//

import UIKit
import SnapKit
import Then

final class QuizView: UIView {
    
    // MARK: - UI Components
    
    /// 퀴즈 화면 상단 타이틀 레이블 ("퀴즈 시간")
    private let titleLabel = UILabel().then {
        $0.text = "퀴즈 시간"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 32, weight: .bold)
    }
    
    /// 단어 카드 뷰 (퀴즈 문제 출제 영역)
    private let wordCardView = WordCardView()
    
    /// 사용자가 "외웠어요!" 선택 시 누르는 버튼 (정답 처리용)
    private let correctButton = UIButton().then {
        $0.setTitle("← 외웠어요 !", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.setTitleColor(.gray, for: .normal)
        $0.contentHorizontalAlignment = .left
    }
    
    /// 사용자가 "못 외웠어요" 선택 시 누르는 버튼 (오답 처리용)
    private let incorrectButton = UIButton().then {
        $0.setTitle("못 외웠어요 →", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.setTitleColor(.gray, for: .normal)
        $0.contentHorizontalAlignment = .right
    }
    
    /// 수평 스택뷰 (정답, 오답)
    private lazy var choiceStackView = UIStackView(
        arrangedSubviews: [
            correctButton,
            incorrectButton
        ]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.distribution = .fillEqually
    }
    
    private let quizStatusView = QuizStatusView()
    
    // MARK: - Initailizer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Configure

private extension QuizView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        backgroundColor = .white
    }
    
    func setHierarchy() {
        [
            titleLabel,
            wordCardView,
            choiceStackView,
            quizStatusView,
        ].forEach { addSubview($0) }
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview()
        }
        
        wordCardView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(50)
            $0.height.equalTo(wordCardView.snp.width).multipliedBy(1.6).priority(.low)
        }
        
        choiceStackView.snp.makeConstraints {
            $0.top.equalTo(wordCardView.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        quizStatusView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(choiceStackView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(100)
        }
    }
}
