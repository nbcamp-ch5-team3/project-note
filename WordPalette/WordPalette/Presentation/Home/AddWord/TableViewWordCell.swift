//
//  WordTableViewCell.swift
//  WordPalette
//
//  Created by iOS study on 5/22/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class TableViewWordCell: UITableViewCell {
    
    // MARK: - Properties
    static let id = "AddWordCell"
    var addButtonTap: Observable<Void> {
        addButton.rx.tap.asObservable()
    }
    
    var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - UI Components
    private let containerView = UIView().then {
        $0.backgroundColor = UIColor.systemGray6
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private let wordLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
        $0.textColor = .black
    }
    
    private let exampleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
    }
    
    private let addButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        $0.tintColor = .black
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(wordLabel)
        containerView.addSubview(exampleLabel)
        containerView.addSubview(addButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 25, bottom: 5, right: 25))
        }
        
        wordLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualTo(addButton.snp.leading).offset(-10)
        }
        
        exampleLabel.snp.makeConstraints { make in
            make.top.equalTo(wordLabel.snp.bottom).offset(10)
            make.leading.equalTo(wordLabel)
            make.trailing.lessThanOrEqualTo(addButton.snp.leading).offset(-10)
            make.bottom.equalToSuperview().inset(12)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(30)
        }
    }
    
    // MARK: - Computed Property
    var wordText: String? { wordLabel.text }
    var exampleText: String? { exampleLabel.text }
    var publicContainerView: UIView { containerView }
    var publicAddButton: UIButton { addButton }
    
    // MARK: - configure Methods
    func configure(word: String, example: String) {
        wordLabel.text = word
        exampleLabel.text = example
    }

}
