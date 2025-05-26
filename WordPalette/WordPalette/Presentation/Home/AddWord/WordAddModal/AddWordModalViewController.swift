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
    /// 입력 바인딩: 닫기 버튼과 저장 버튼의 탭 이벤트를 바인딩
    private func bindInput() {
        bindCloseButton()
        bindSaveButton()
    }
    
    // MARK: - Output Binding
    /// 출력 바인딩: 닫기 및 저장 액션을 바인딩
    private func bindOutput() {
        bindCloseAction()
        bindSaveAction()
    }
    
    /// 닫기 버튼의 탭 이벤트를 Subject에 바인딩
    private func bindCloseButton() {
        modalView.closeButton.rx.tap
            .bind(to: closeButtonTabSubject)
            .disposed(by: disposeBag)
    }
    
    /// 저장 버튼의 탭 이벤트를 Subject에 바인딩
    private func bindSaveButton() {
        modalView.saveButton.rx.tap
            .bind(to: saveButtonTapSubject)
            .disposed(by: disposeBag)
    }
    
    /// 닫기 액션: 닫기 버튼 탭 시 모달을 닫음
    private func bindCloseAction() {
        closeButtonTabSubject
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    /// 저장 액션: 저장 버튼 탭 시 입력값을 검증하고, 중복 체크 후 저장을 시도
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
    /// 단어 저장 시 중복 체크를 수행하고, 중복이 없으면 저장 확인 알림을 띄움
    private func checkDuplicateAndSave(word: String, meaning: String, example: String?) {
        guard let checkDuplicate = onCheckDuplicate else {
            dismissAndSave(word: word, meaning: meaning, example: example)
            return
        }
        
        checkDuplicate(word) { [weak self] (isDuplicate, level) in
            DispatchQueue.main.async {
                if isDuplicate {
                    self?.showAlert(message: self?.duplicateMessage(for: level) ?? "이미 등록된 단어입니다.")
                } else {
                    self?.showConfirmationAlert(word: word, meaning: meaning, example: example)
                }
            }
        }
    }
    
    /// 중복 메시지 생성 함수
    private func duplicateMessage(for level: Level?) -> String {
        level != nil ? "\(level!.rawValue)에 이미 있는 단어입니다." : "이미 등록된 단어입니다."
    }
    
    /// 단어 추가 확인 알림창을 띄움
    private func showConfirmationAlert(word: String, meaning: String, example: String?) {
        let alert = UIAlertController(title: "단어 추가", message: "단어를 추가하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            self?.dismissAndSave(word: word, meaning: meaning, example: example)
        })
        present(alert, animated: true)
    }
    
    /// 모달을 닫으면서 단어 저장 콜백을 실행함
    private func dismissAndSave(word: String, meaning: String, example: String?) {
        dismiss(animated: true) { [weak self] in
            self?.onSaveButtonTap?(word, meaning, example)
        }
    }
    
    /// 메시지 알림창을 띄움
    private func showAlert(message: String) {
        view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self?.present(alert, animated: true)
        }
    }
}
