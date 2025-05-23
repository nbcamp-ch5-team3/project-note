//
//  WordCardView.swift
//  WordPalette
//
//  Created by 박주성 on 5/22/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class WordCardView: UIView {
    
    // MARK: - Propeties
    
    private let disposeBag = DisposeBag()
    
    private var isFront: Bool = true
    
    // MARK: - UI Components
    
    /// 단어 (ex. Apple)
    private let wordLabel = UILabel().then {
        $0.text = "Apple"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 32, weight: .bold)
    }
    
    /// 에문 (ex. I ate an apple)
    private let exampleLabel = UILabel().then {
        $0.text = "I ate an apple"
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 15)
    }
    
    /// 수직 스택뷰 (단어, 예문)
    private lazy var wordStackView = UIStackView(
        arrangedSubviews: [
            wordLabel,
            exampleLabel
        ]
    ).then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    /// 번역 확인 버튼
    private let translationHintButton = UIButton().then {
        $0.setTitle("터치해서 번역 확인", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.setTitleColor(.gray, for: .normal)
    }
    
    // MARK: - Initailizer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func handleCardFlip() {
        isFront.toggle()
        
        UIView.transition(
            with: self,
            duration: 0.5,
            options: isFront ? .transitionFlipFromRight : .transitionFlipFromLeft) {
                self.backgroundColor = self.isFront ? .white : .customMango
            }
    }
}

// MARK: - Configure

private extension WordCardView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }
    
    func setAttributes() {
        backgroundColor = .white
        
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
    
    func setHierarchy() {
        [wordStackView, translationHintButton].forEach { addSubview($0) }
    }
    
    func setConstraints() {
        wordStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        translationHintButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(60)
        }
    }
    
    private func setBindings() {
        translationHintButton.rx.tap
            .bind(with: self) { owner, _  in
                owner.handleCardFlip()
            }
            .disposed(by: disposeBag)
    }
}
