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
                
                // 클로저 호출해서 데이터 전달
                self.onSaveButtonTap?(word, meaning, self.modalView.exampleText)
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helper Methods (Alert)
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
