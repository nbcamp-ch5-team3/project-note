//
//  AddWordViewController.swift
//  WordPalette
//
//  Created by iOS study on 5/22/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AddWordViewController: UIViewController {

    private let viewModel: AddWordViewModel = {
        // 임시 DI (나중에 DI컨테이너로 대체)
        let localDataSource = WordLocalDataSource()
        let coreDataManager = CoreDataManager()
        let unsolvedRepo = UnsolvedWordRepositoryImpl(localDataSource: localDataSource, coredataManager: coreDataManager)
        let addWordRepo = AddWordRepositoryImpl(localDataSource: localDataSource, unsolvedWordRepository: unsolvedRepo)
        let useCase = AddWordUseCaseImpl(repository: addWordRepo) // UseCaseImpl 구현 필요!
        return AddWordViewModel(useCase: useCase)
    }()
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let addWordView = AddWordView()
    private let levelSubject = BehaviorRelay<Level>(value: .beginner)
    private let refreshSubject = PublishSubject<Void>()
    private let addWordTapSubject = PublishSubject<WordEntity>()

    // MARK: - Test Data
    let words: [(word: String, example: String)] = [
        ("apple 사과", "I ate an apple this morning."),
        ("banana 바나나", "Bananas are yellow."),
        ("cat 고양이", "The cat is sleeping."),
        ("dog 개ddddddddddsgfdgfsdgfsgdfsgdfgsdfgsfgsfdgfsdg", "My dog loves to playbbbbbbbbjgnbownbofnboiniorbnoiwbnionoinoirnboienbiownbioenrbiobrw.")
    ]

    // MARK: - Life Cycle
    override func loadView() {
        self.view = addWordView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewCell()
        setupDelegate()
        setupBinding()
    }

    // MARK: - Setup
    private func setupTableViewCell() {
        addWordView.tableView.register(TableViewWordCell.self, forCellReuseIdentifier: TableViewWordCell.id)
    }

    private func setupDelegate() {
        addWordView.tableView.dataSource = self
        addWordView.tableView.delegate = self
        addWordView.searchBar.delegate = self
    }

    //MARK: - addButton Action(RX)
    private func setupBinding() {
        addWordView.floatingButton.rx.tap
            .bind(with: self) { owner, _ in
                let modal = AddWordModalViewController()
                modal.modalPresentationStyle = .overFullScreen
                owner.present(modal, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension AddWordViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewWordCell.id, for: indexPath) as? TableViewWordCell else {
            return UITableViewCell()
        }
        let data = words[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(word: data.word, example: data.example)
        return cell
    }
}

extension AddWordViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
