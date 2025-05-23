//
//  AddWordView.swift
//  WordPalette
//
//  Created by iOS study on 5/22/25.
//

import UIKit
import SnapKit
import Then

final class AddWordView: UIView {
    // MARK: - UI Components
    let searchBar = UISearchBar().then {
        $0.placeholder = "단어를 검색해보세요"
        $0.tintColor = .label
        $0.searchBarStyle = .minimal
        $0.backgroundImage = UIImage()
        $0.backgroundColor = .clear
        
        let textField = $0.searchTextField
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.font = UIFont.systemFont(ofSize: 17)
    }

    let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 70
    }

    let floatingButton = UIButton().then {
        $0.backgroundColor = .customOrange
        $0.setTitle("단어 직접 추가하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    let refreshControl = UIRefreshControl().then {
        $0.tintColor = .clear 
        $0.backgroundColor = .clear
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .systemBackground
        [searchBar, tableView, floatingButton].forEach { addSubview($0) }
        
        tableView.refreshControl = refreshControl
    }

    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(5)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.bottom.equalTo(floatingButton.snp.top).offset(-15)
            make.leading.trailing.equalToSuperview()
        }

        floatingButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(55)
        }
    }
}
