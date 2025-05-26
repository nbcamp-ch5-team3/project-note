//
//  AddWordModalView.swift
//  WordPalette
//
//  Created by iOS study on 5/22/25.
//

import UIKit
import SnapKit
import Then

final class AddWordModalView: UIView {
    
    //MARK: - UI Components
    private let titleLabel = UILabel().then {
        $0.text = "단어 추가하기"
        $0.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        $0.textAlignment = .center
        $0.textColor = .black
    }
    
    private let wordTextView = UITextView().then {
        $0.setPlaceholder("영단어를 입력하세요")
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor(white: 0.95, alpha: 1)
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.autocapitalizationType = .none
        $0.keyboardType = .asciiCapable
    }
    
    private let meaningTextView = UITextView().then {
        $0.setPlaceholder("한글 뜻을 입력하세요")
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor(white: 0.95, alpha: 1)
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.keyboardType = .default
    }
    
    private let exampleTextView = UITextView().then {
        $0.setPlaceholder("예문을 입력하세요 (선택)")
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor(white: 0.95, alpha: 1)
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.keyboardType = .default
    }
    
    private let _saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.backgroundColor = .customOrange
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
    }
    
    private let _closeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = .systemGray
        $0.backgroundColor = .clear
    }
    
    private let contentStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .fill
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupDelegate()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 20
        clipsToBounds = true
        
        [closeButton, contentStack].forEach { self.addSubview($0) }
        
        [titleLabel, wordTextView, meaningTextView, exampleTextView, saveButton].forEach { contentStack.addArrangedSubview($0) }
    }
    
    private func setupDelegate() {
        wordTextView.delegate = self
        meaningTextView.delegate = self
        exampleTextView.delegate = self
    }
    
    private func setupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.width.height.equalTo(28)
        }
        
        contentStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-24)
        }
        
        wordTextView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(58)
        }
        
        meaningTextView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(58)
        }
        
        exampleTextView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(84)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Computed Property
    var saveButton: UIButton { _saveButton }
    var closeButton: UIButton { _closeButton }
    var wordText: String? { wordTextView.text }
    var meaningText: String? { meaningTextView.text }
    var exampleText: String? { exampleTextView.text }
}

extension UITextView {
    func setPlaceholder(_ text: String, color: UIColor = .systemGray) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = text
        placeholderLabel.textColor = color
        placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.numberOfLines = 0
        self.addSubview(placeholderLabel)
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(8)
        }
        
        // 텍스트가 바뀔 때마다 placeholder 숨기기/보이기
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: self, queue: .main) { [weak self] _ in
            placeholderLabel.isHidden = !(self?.text?.isEmpty ?? true)
        }
        
        // 처음에는 텍스트가 비어있으면 보여주기
        placeholderLabel.isHidden = !self.text.isEmpty
    }
}

extension AddWordModalView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if textView == wordTextView {
                meaningTextView.becomeFirstResponder()
                return false
            } else if textView == meaningTextView {
                exampleTextView.becomeFirstResponder()
                return false
            } else if textView == exampleTextView {
                exampleTextView.resignFirstResponder()
                return false
            }
        }
        
        // wordTextView: 영어 소문자만 (대문자, 특수문자, 숫자 모두 불가)
        if textView == wordTextView {
            let allowed = CharacterSet.lowercaseLetters
            for scalar in text.unicodeScalars {
                if !allowed.contains(scalar) && text != "" {
                    return false
                }
            }
            return true
        }
        
        // meaningTextView: 한글만 허용
        if textView == meaningTextView {
            for scalar in text.unicodeScalars {
                let v = scalar.value
                // 완성형 한글, 자음, 모음 모두 허용
                let isHangul = (v >= 0xAC00 && v <= 0xD7A3)
                    || (v >= 0x3131 && v <= 0x318E)    
                if !isHangul && text != "" {
                    return false
                }
            }
            return true
        }
        
        return true
    }
}
