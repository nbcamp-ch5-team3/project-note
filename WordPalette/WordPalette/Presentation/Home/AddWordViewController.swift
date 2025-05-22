//
//  AddWordViewController.swift
//  WordPalette
//
//  Created by iOS study on 5/22/25.
//

import UIKit
import SnapKit
import Then

class AddWordViewController: UIViewController {
    
    // MARK: - Test Data
    let words: [(word: String, example: String)] = [
        ("apple 사과", "I ate an apple this morning."),
        ("banana 바나나", "Bananas are yellow."),
        ("cat 고양이", "The cat is sleeping."),
        ("dog 개ddddddddddsgfdgfsdgfsgdfsgdfgsdfgsfgsfdgfsdg", "My dog loves to playbbbbbbbbjgnbownbofnboiniorbnoiwbnionoinoirnboienbiownbioenrbiobrw.")
    ]
    
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
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.masksToBounds = true
        
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground

        [searchBar, tableView, floatingButton].forEach { view.addSubview($0) }
        
        setupTableViewCell()
        setupConstraints()
    }
    
    private func setupTableViewCell() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewWordCell.self, forCellReuseIdentifier: TableViewWordCell.id)
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(55)
        }
    }
}

// MARK: - UITableViewDataSource
extension AddWordViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewWordCell.id, for: indexPath) as? TableViewWordCell else {
            return UITableViewCell()
        }
        let data = words[indexPath.row]
        cell.configure(word: data.word, example: data.example)
        _ = cell.wordText
        _ = cell.exampleText
        return cell
    }
}
