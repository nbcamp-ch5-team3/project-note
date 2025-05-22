//
//  StudyWordCell.swift
//  WordPalette
//
//  Created by Quarang on 5/22/25.
//

import UIKit
import SnapKit
import Then

// MARK: - 특정 날짜에 학습한 단어 리스트 셀
final class StudyWordCell: UITableViewCell, UIViewGuide {
    
    static let identifier = "StudyWordCell"
    
    /// 단어
    private let wordLabel = UILabel()
    
    /// 번역된 단어
    private let meaningLabel = UILabel()
    
    /// 단어 스택 (단어 + 번역된 단어)
    private let wordStack = UIStackView()
    
    /// 레벨 단어
    private let levelLabel = PaddingLabel(top: 4, left: 18, bottom: 4, right: 18)
    
    func configureAttributes() {
        
        selectionStyle = .none
        
        wordLabel.do {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 18, weight: .semibold)
        }
        
        meaningLabel.do {
            $0.font = .systemFont(ofSize: 16)
        }
        
        wordStack.do {
            $0.axis = .vertical
            $0.spacing = 4
        }
        
        levelLabel.do {
            $0.textColor = .white
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
    }
    
    func configureLayout() {
        wordStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }
        
        levelLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    
    func configureSubView() {
        
        [wordLabel, meaningLabel]
            .forEach { wordStack.addArrangedSubview($0) }
        
        [wordStack, levelLabel]
            .forEach { contentView.addSubview($0) }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        wordLabel.text = nil
        meaningLabel.attributedText = nil
        levelLabel.text = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAttributes()
        configureSubView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 셀 컴포넌트 설정
    func configure(_ word: WordMock) {
        guard let isCorrect = word.isCorrect else { return }
        
        let text = NSMutableAttributedString(string: "\(isCorrect ? "O" : "X") \(word.meaning)")
        text.addAttribute(.foregroundColor, value: isCorrect ? UIColor.green : UIColor.red, range: NSRange(location: 0, length: 1))
        text.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 1, length: text.string.count - 1))
        
        wordLabel.text = word.word
        meaningLabel.attributedText = text
        levelLabel.text = word.level.rawValue
        levelLabel.backgroundColor = word.level.color
    }
}
