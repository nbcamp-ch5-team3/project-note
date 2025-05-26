//
//  ProfileSectionView.swift
//  WordPalette
//
//  Created by Quarang on 5/21/25.
//

import UIKit
import Then
import SnapKit

// MARK: - 프로필 정보 섹션 뷰
final class ProfileSectionView: UIView, UIViewGuide {
    
    /// 메달
    private let profileLabel = PaddingLabel(top: -4, left: 7, bottom: 10, right: 7)
    
    /// 티어
    private let tierLabel = UILabel()
    
    /// 티어까지 몇점
    private let descriptionLabel = UILabel()
    
    /// 티어 관련 스택 뷰
    private let tierStackView = UIStackView()
    
    /// 남은 점수 인디케이터
    private let remainingTierProgressView = UIProgressView()
    
    /// 남은 점수
    private let remainingNextTierLabel = UILabel()
    
    
    func configureAttributes() {
        
        backgroundColor = .white
        
        profileLabel.do {
            $0.font = .systemFont(ofSize: UIDevice.current.isiPhoneSE ? 42 : 54, weight: .medium)
            $0.layer.cornerRadius = UIDevice.current.isiPhoneSE ? 30 : 35
            $0.clipsToBounds = true
        }
        
        tierLabel.do {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 20, weight: .medium)
        }
        
        descriptionLabel.do {
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 16, weight: .medium)
        }
        
        tierStackView.do {
            $0.axis = .vertical
            $0.spacing = 6
        }
        
        remainingTierProgressView.do {
            $0.trackTintColor = .customMango.withAlphaComponent(0.25)
            $0.progressTintColor = .customMango
        }
        
        remainingNextTierLabel.do {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 14, weight: .medium)
        }
    }
    
    func configureLayout() {
        profileLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIDevice.current.isiPhoneSE ? 18 : 24)
            $0.leading.equalToSuperview().inset(UIDevice.current.isiPhoneSE ? 40 : 24)
        }
        
        tierStackView.snp.makeConstraints {
            $0.leading.equalTo(profileLabel.snp.trailing).offset(UIDevice.current.isiPhoneSE ? 18 : 24)
            $0.centerY.equalTo(profileLabel)
        }
        
        remainingTierProgressView.snp.makeConstraints {
            $0.top.equalTo(profileLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(UIDevice.current.isiPhoneSE ? 40 : 24)
            $0.height.equalTo(8)
        }
        
        remainingNextTierLabel.snp.makeConstraints {
            $0.top.equalTo(remainingTierProgressView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(UIDevice.current.isiPhoneSE ? 40 : 24)
        }
        
    }
    
    func configureSubView() {
        
        [tierLabel, descriptionLabel]
            .forEach { tierStackView.addArrangedSubview($0) }
        
        [profileLabel, tierStackView, remainingTierProgressView, remainingNextTierLabel]
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

    /// 데이터 업데이트
    func configure(_ tierType: TierType?, currentScore: Int) {
        guard let tierType else { return }
        
        profileLabel.text = tierType.emoji
        profileLabel.backgroundColor = tierType.backgroundColor
        
        tierLabel.text = tierType.rawValue
        
        if let nextTier = tierType.nextTier {
            descriptionLabel.text = nextTier.rawValue + "까지 \(tierType.scoreRange.upperBound - currentScore)점"
        } else {
            descriptionLabel.text = "최고 레벨을 달성했습니다! 🎉🥳"
        }
        
        remainingTierProgressView.progress = Float(currentScore) / Float(tierType.scoreRange.upperBound)
        remainingNextTierLabel.text = "\(currentScore)점 / \(tierType.scoreRange.upperBound - 1)점"
    }
}
