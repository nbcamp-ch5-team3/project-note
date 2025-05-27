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
    
    /// 닫기 버튼
    private let dismissButton = UIButton()
    
    func configureAttributes() {
        
        backgroundColor = .white
        
        dateLabel.do {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 24, weight: .semibold)
        }
        
        statStackView.do {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
        }
        
        cheeringLabel.do {
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
            $0.backgroundColor = .white
        }
        
        dismissButton.do {
            $0.setImage(UIImage(systemName: "xmark"), for: .normal)
            $0.tintColor = .black
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
        
        dismissButton.snp.makeConstraints {
            $0.top.trailing.equalTo(safeAreaLayoutGuide).inset(24)
        }
    
    }
    
    func configureSubView() {
        
        [memorizationLabel, unMemorizationLabel, memorizationRateLabel]
            .forEach { statStackView.addArrangedSubview($0) }
        
        [dateLabel, statStackView, cheeringLabel, wordLabel, wordSegmentControl, wordTableView, dismissButton]
            .forEach { addSubview($0) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttributes()
        configureSubView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 뷰 컴포넌트 데이터 설정
    func configure(date:Date, memo: Int, unMemo: Int) {
        dateLabel.text = date.toString()
        memorizationLabel.configure(num: "\(memo)개", text: "암기 완료")
        unMemorizationLabel.configure(num: "\(unMemo)", text: "미암기")
        
        let total = memo + unMemo
        let rate = total == 0 ? 0 : Int((Double(memo) / Double(total)) * 100)
        
        // 암기율 50% 기준으로 표시
        memorizationRateLabel.configure(num: "\(rate)%", text: "암기율", color: rate > 50 ? .systemGreen : .systemPink.withAlphaComponent(0.8))
        cheeringLabel.text = rate > 50  ? "아주 잘하고 있어요! 🎉" : "아직 더 분발하셔야 해요 😅"
    }
    
    // MARK: 외부 접근 가능 메서드
    var getWordTableView: UITableView {
        wordTableView
    }
    
    var getDismissButton: UIButton {
        dismissButton
    }
    
    var getSegmentControl: UISegmentedControl {
        wordSegmentControl
    }
}


enum WordStatisticsType: String, CaseIterable {
    case all = "모두"
    case memorization = "암기"
    case unMemorization = "미암기"
}
