//
//  StatLabel.swift
//  WordPalette
//
//  Created by Quarang on 5/21/25.
//

import UIKit
import SnapKit
import Then

// MARK: - 통계 기록에 적히는 스탯 라벨 (예시: 6개, 암기완료 등)
final class StatLabel: UIStackView {
    
    /// 숫자 라벨
    private let numberLabel = UILabel()
    
    /// 타이틀 라벨
    private let titleLabel = UILabel()
    
    func configureAttributes() {
        
        axis = .vertical
        alignment = .center
        spacing = 12
        
        numberLabel.do {
            $0.textColor = .black
            $0.font = .boldSystemFont(ofSize: 22)
        }
        
        titleLabel.do {
            $0.textColor = .systemGray
            $0.font = .systemFont(ofSize: 18)
        }
    }
    
    func configureSubView() {
        [numberLabel, titleLabel]
            .forEach { addArrangedSubview($0) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttributes()
        configureSubView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(num: String, text: String, color: UIColor = .black) {
        numberLabel.text = num
        titleLabel.text = text
        numberLabel.textColor = color
    }
    
}
