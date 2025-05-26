//
//  StudyHistoryView.swift
//  WordPalette
//
//  Created by Quarang on 5/21/25.
//

import UIKit
import Then
import SnapKit

// MARK: - 나의 학습기록 UIView
final class StudyHistoryView: UIView, UIViewGuide {
    
    
    /// 배경색
    private let backGroundView = UIView()
    
    /// 타이틀
    private let titleLabel = PaddingLabel(top: 24, left: UIDevice.current.isiPhoneSE ? 36 : 24, bottom: 0, right: 0)
    
    /// 프로필 섹션 뷰
    private let profileSectionView = ProfileSectionView()
    
    /// 달력
    private let calendarView = UICalendarView()
    
    /// 달력 배경 (inset을 주고 배경을 깔기 위함)
    private let calendarBackgroundView = UIView()
    
    func configureAttributes() {
        
        backgroundColor = .white
        
        backGroundView.do {
            $0.backgroundColor = .systemGray6
        }
        
        titleLabel.do {
            $0.text = "나의 학습 기록"
            $0.textColor = .black
            $0.textAlignment = .left
            $0.backgroundColor = .white
            $0.font = .systemFont(ofSize: UIDevice.current.isiPhoneSE ? 24 : 32, weight: .bold)
        }
        
        calendarBackgroundView.do {
            $0.backgroundColor = .white
        }
        
        calendarView.do {
            $0.calendar = Calendar(identifier: .gregorian)
            $0.backgroundColor = .white
            $0.locale = Locale(identifier: "ko_KR")
            $0.tintColor = .customOrange
            $0.availableDateRange = DateInterval(start: .distantPast, end: .distantFuture)
        }
    }
    
    func configureSubView() {
        [backGroundView, titleLabel, profileSectionView, calendarBackgroundView, calendarView]
            .forEach { addSubview($0) }
    }
    
    func configureLayout() {
        
        backGroundView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        profileSectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(profileSectionView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(UIDevice.current.isiPhoneSE ? 40 : 0)
            $0.height.equalTo(UIDevice.current.isiPhoneSE ? 380 : 480)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        calendarBackgroundView.snp.makeConstraints {
            $0.top.equalTo(profileSectionView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
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
    
    // MARK: 외부 접근 가능 메서드
    var getProfileSectionView: ProfileSectionView {
        profileSectionView
    }
    
    var getCalendarView: UICalendarView {
        calendarView
    }
}

