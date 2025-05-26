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
        bindCloseButton()
        bindSaveButton()
    }
    
    /// 닫기 버튼의 탭 이벤트를 Subject에 바인딩
    private func bindCloseButton() {
        modalView.closeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    /// 저장 버튼의 탭 이벤트를 Subject에 바인딩
    private func bindSaveButton() {
        modalView.saveButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.handleSaveButtonTap()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helper Methods
    /// 단어 저장 시 중복 체크를 수행하고, 중복이 없으면 저장 확인 알림을 띄움
    private func handleSaveButtonTap() {
        // 입력값 검증
        guard let word = modalView.wordText?.trimmingCharacters(in: .whitespacesAndNewlines),
              !word.isEmpty,
              let meaning = modalView.meaningText?.trimmingCharacters(in: .whitespacesAndNewlines),
              !meaning.isEmpty else {
            showAlert(message: "영단어와 한글 뜻은 필수 입력사항입니다.")
            return
        }
        
        let example = modalView.exampleText?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 중복 체크
        guard let checkDuplicate = onCheckDuplicate else {
            showConfirmationAlert(word: word, meaning: meaning, example: example)
            return
        }
        
        checkDuplicate(word) { [weak self] isDuplicate, level in
            DispatchQueue.main.async {
                if isDuplicate {
                    let message = level != nil ? "\(level!.rawValue)에 이미 있는 단어입니다." : "이미 등록된 단어입니다."
                    self?.showAlert(message: message)
                } else {
                    self?.showConfirmationAlert(word: word, meaning: meaning, example: example)
                }
            }
        }
    }
    
    /// 단어 추가 확인 알림창을 띄움
    private func showConfirmationAlert(word: String, meaning: String, example: String?) {
        let alert = UIAlertController(title: "단어 추가", message: "단어를 추가하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            self?.dismiss(animated: true) {
                self?.onSaveButtonTap?(word, meaning, example)
            }
        })
        
        present(alert, animated: true)
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
