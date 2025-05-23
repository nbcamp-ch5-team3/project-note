//
//  AddWordModalViewController.swift
//  WordPalette
//
//  Created by iOS study on 5/22/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AddWordModalViewController: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let modalView = AddWordModalView()
    
    // MARK: - Input Subjects
    private let saveButtonTapSubject = PublishSubject<Void>()
    private let closeButtonTabSubject = PublishSubject<Void>()
    
    
    // MARK: - Callback
    var onSaveButtonTap: ((String, String, String?) -> Void)?
    var onCheckDuplicate: ((String, @escaping (Bool, Level?) -> Void) -> Void)?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addSubview(modalView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        modalView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(320)
            make.height.greaterThanOrEqualTo(400)
        }
    }
    
    // MARK: - Bind
    private func bind() {
        bindInput()
        bindOutput()
    }
    
    // MARK: - Input Binding
    private func bindInput() {
        bindCloseButton()
        bindSaveButton()
    }
    
    // MARK: - Output Binding
    private func bindOutput() {
        bindCloseAction()
        bindSaveAction()
    }
    
    private func bindCloseButton() {
        modalView.closeButton.rx.tap
            .bind(to: closeButtonTabSubject)
            .disposed(by: disposeBag)
    }
    
    private func bindSaveButton() {
        modalView.saveButton.rx.tap
            .bind(to: saveButtonTapSubject)
            .disposed(by: disposeBag)
    }
    
    private func bindCloseAction() {
        closeButtonTabSubject
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindSaveAction() {
        saveButtonTapSubject
            .bind(with: self) { owner, _ in
                // 입력값 검증
                guard let word = self.modalView.wordText,
                      !word.isEmpty,
                      let meaning = self.modalView.meaningText,
                      !meaning.isEmpty else {
                    // 필수 입력값이 없으면 Alert
                    owner.showAlert(message: "영단어와 한글 뜻은 필수 입력사항입니다.")
                    return
                }
                
                self.checkDuplicateAndSave(word: word, meaning: meaning, example: self.modalView.exampleText)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helper Methods
    
    private func checkDuplicateAndSave(word: String, meaning: String, example: String?) {
        guard let checkDuplicate = onCheckDuplicate else {
            dismissAndSave(word: word, meaning: meaning, example: example)
            return
        }
        
        // 중복 체크
        checkDuplicate(word) { [weak self] (isDuplicate, level) in
            DispatchQueue.main.async {
                if isDuplicate {
                    let message: String
                    if let level = level {
                        message = "\(word)는 \(level.rawValue)에 이미 있는 단어입니다."
                    } else {
                        message = "이미 등록된 단어입니다."
                    }
                    self?.showAlert(message: message)
                } else {
                    self?.showConfirmationAlert(word: word, meaning: meaning, example: example)
                }
            }
        }
    }
    
    private func showConfirmationAlert(word: String, meaning: String, example: String?) {
        let exampleText = example?.isEmpty == false ? "\n예문: \(example!)" : ""
        let message = "\(word): \(meaning)\(exampleText)\n\n단어를 추가하시겠습니까?"
        
        let alert = UIAlertController(title: "단어 추가", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            self?.dismissAndSave(word: word, meaning: meaning, example: example)
        })
        
        present(alert, animated: true)
    }
    
    private func dismissAndSave(word: String, meaning: String, example: String?) {
        dismiss(animated: true) { [weak self] in
            self?.onSaveButtonTap?(word, meaning, example)
        }
    }
    
    private func showAlert(message: String) {
        view.endEditing(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self?.present(alert, animated: true)
        }
    }
}
