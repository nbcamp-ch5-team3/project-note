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
    
    
    func configureAttributes() {
        
        backgroundColor = .white
        
    }
    
    func configureLayout() {
        
    }
    
    func configureSubView() {
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
}
