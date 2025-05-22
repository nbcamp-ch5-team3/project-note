//
//  StudyStatisticsView.swift
//  WordPalette
//
//  Created by Quarang on 5/21/25.
//

import UIKit
import Then
import SnapKit

// MARK: - 학습 통계 뷰
final class StudyStatisticsView: UIView, UIViewGuide {
    
    /// 날짜
    private let dateLabel = UILabel()
    
    /// 암기
    private let memorizationLabel = StatLabel()
    
    /// 미암기
    private let unMemorizationLabel = StatLabel()
    
    /// 암기율
    private let memorizationRateLabel = StatLabel()
    
    /// 스탯 스택 (암기 + 미암기 + 암기율)
    private let statStackView = UIStackView()
    
    /// 응원 메세지
    private let cheeringLabel = PaddingLabel(top: 8, left: 0, bottom: 8, right: 0)
    
    /// 학습단어 타이틀
    private let wordLabel = UILabel()
    
    /// 세그먼트 컨트롤
    private let wordSegmentControl = UISegmentedControl(items: WordStatisticsType.allCases.map { $0.rawValue })
    
    /// 테이블 뷰
    private let wordTableView = UITableView()
    
    
    func configureAttributes() {
        
        backgroundColor = .white
        
        dateLabel.do {
            $0.text = "2023.04.04"
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 24, weight: .semibold)
        }
        
        statStackView.do {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
        }
        
        cheeringLabel.do {
            $0.text = "아직 더 분발하셔야 해요 😅"
            $0.textColor = .black
            $0.textAlignment = .center
            $0.backgroundColor = .gray.withAlphaComponent(0.1)
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        
        wordLabel.do {
            $0.text = "학습 단어"
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 24, weight: .semibold)
        }
        
        wordSegmentControl.do {
            $0.selectedSegmentIndex = 0
            $0.overrideUserInterfaceStyle = .light
        }
        
        wordTableView.do {
            $0.rowHeight = 64
        }
        
    }
    
    func configureLayout() {
        dateLabel.snp.makeConstraints {
            $0.top.leading.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        statStackView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(56)
        }
        
        cheeringLabel.snp.makeConstraints {
            $0.top.equalTo(statStackView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        wordLabel.snp.makeConstraints {
            $0.top.equalTo(cheeringLabel.snp.bottom).offset(24)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        wordSegmentControl.snp.makeConstraints {
            $0.top.equalTo(wordLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        wordTableView.snp.makeConstraints {
            $0.top.equalTo(wordSegmentControl.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    
    }
    
    func configureSubView() {
        
        [memorizationLabel, unMemorizationLabel, memorizationRateLabel]
            .forEach { statStackView.addArrangedSubview($0) }
        
        [dateLabel, statStackView, cheeringLabel, wordLabel, wordSegmentControl, wordTableView]
            .forEach { addSubview($0) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttributes()
        configureSubView()
        configureLayout()
        
        configure()   // 나중에 지울 예정
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 뷰 컴포넌트 데이터 설정
    func configure() {
        memorizationLabel.configure(num: "6개", text: "암기 완료")
        unMemorizationLabel.configure(num: "12개", text: "미암기")
        memorizationRateLabel.configure(num: "30%", text: "암기율", color: .systemPink.withAlphaComponent(0.8))
    }
    
    // MARK: 외부 접근 가능 메서드
    var getWordTableView: UITableView {
        wordTableView
    }
}


enum WordStatisticsType: String, CaseIterable {
    case all = "모두"
    case memorization = "암기"
    case unMemorization = "미암기"
}
