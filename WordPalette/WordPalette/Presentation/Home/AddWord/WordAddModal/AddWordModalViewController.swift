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
                // 저장 로직 작성예정
                // 사용 형태: let word = self?.modalView.wordText
                // let meaning = self?.modalView.meaningText
                // let example = self?.modalView.exampleText
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
