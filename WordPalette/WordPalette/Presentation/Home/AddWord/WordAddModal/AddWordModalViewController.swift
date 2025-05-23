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
    
    var onSaveButtonTap: ((String, String, String?) -> Void)?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupConstraints()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addSubview(modalView)
    }
    
    private func setupConstraints() {
        modalView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(320)
            make.height.greaterThanOrEqualTo(400)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Rx Binding (Button Action)
    private func setupActions() {
        modalView.closeButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        modalView.saveButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                
                // 입력값 검증
                guard let word = self.modalView.wordText,
                      !word.isEmpty,
                      let meaning = self.modalView.meaningText,
                      !meaning.isEmpty else {
                    // 필수 입력값이 없으면 Alert
                    self.showAlert(message: "영단어와 한글 뜻은 필수 입력사항입니다.")
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
