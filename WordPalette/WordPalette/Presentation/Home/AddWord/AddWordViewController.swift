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
        let useCase = AddWordUseCaseImpl(repository: addWordRepo)
        return AddWordViewModel(useCase: useCase)
    }()
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let addWordView = AddWordView()
    
    // MARK: - Input Subjects
    private let viewWillAppearSubject = PublishSubject<Void>()
    private let refreshSubject = PublishSubject<Void>()
    private let searchTextSubject = BehaviorSubject<String>(value: "")
    private let addWordTapSubject = PublishSubject<WordEntity>()
    private let addCustomWordTapSubject = PublishSubject<(en: String, ko: String, example: String?)>()
    private let selectedLevelSubject = BehaviorRelay<Level>(value: .beginner)
    
    // MARK: - Output Properties
    private var words: [WordEntity] = []
    
    // MARK: - Life Cycle
    override func loadView() {
        self.view = addWordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewCell()
        setupDelegate()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearSubject.onNext(())
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
    
    // MARK: - Bind
    private func bind() {
        let input = AddWordViewModel.Input(
            viewWillAppear: viewWillAppearSubject.asObservable(),
            refreshTrigger: refreshSubject.asObservable(),
            searchText: searchTextSubject.asObservable(),
            addWordTap: addWordTapSubject.asObservable(),
            addCustomWordTap: addCustomWordTapSubject.asObservable(),
            selectedLevel: selectedLevelSubject.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        bindInput()
        bindOutput(output)
    }
    
    // MARK: - Input Binding
    private func bindInput() {
        bindFloatingButton()
        bindSearchBar()
        bindRefreshControl()
        bindLevelSegmentControl()
    }

    // MARK: - Output Binding
    private func bindOutput(_ output: AddWordViewModel.Output) {
        bindWordsOutput(output.words)
        bindAddResultOutput(output.addResult)
        bindAlertOutput(output.showAlert)
    }
    
    // MARK: - Individual Input Bindings
    private func bindFloatingButton() {
        addWordView.floatingButton.rx.tap
            .bind(with: self) { owner, _ in
                let modal = AddWordModalViewController()
                modal.modalPresentationStyle = .overFullScreen
                
                // 모달에서 저장 버튼 탭 시 처리
                modal.onSaveButtonTap = { [weak owner] en, ko, example in
                    owner?.addCustomWordTapSubject.onNext((en: en, ko: ko, example: example))
                }
                
                owner.present(modal, animated: true)
            }
            .disposed(by: disposeBag)
    }

    private func bindSearchBar() {
        addWordView.searchBar.rx.text.orEmpty
            .bind(to: searchTextSubject)
            .disposed(by: disposeBag)
    }
    
    private func bindRefreshControl() {
        addWordView.refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: refreshSubject)
            .disposed(by: disposeBag)
    }

    private func bindLevelSegmentControl() {
        // 요기서 사용 X 임의로 틀만 만들어둠
        /*
        addWordView.levelSegmentControl?.rx.selectedSegmentIndex
            .map { index -> Level in
                switch index {
                case 0: return .beginner
                case 1: return .intermediate
                case 2: return .advanced
                default: return .beginner
                }
            }
            .bind(to: selectedLevelSubject)
            .disposed(by: disposeBag)
        */
    }
    
    // MARK: - Individual Output Bindings
    private func bindWordsOutput(_ words: Observable<[WordEntity]>) {
        words
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, words in
                owner.words = words
                owner.addWordView.tableView.reloadData()
                owner.endRefreshingIfNeeded()
            }
            .disposed(by: disposeBag)
    }

    private func bindAddResultOutput(_ addResult: Observable<AddWordResult>) {
        addResult
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, result in
                switch result {
                case .success:
                    // 성공 시 단어 목록 새로고침
                    owner.refreshSubject.onNext(())
                case .fail, .duplicate, .duplicateInLevel:
                    // 실패/중복은 Alert로 처리됨
                    break
                }
            }
            .disposed(by: disposeBag)
    }

    private func bindAlertOutput(_ showAlert: Observable<String>) {
        showAlert
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, message in
                owner.showAlert(message: message)
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Helper Methods
    private func endRefreshingIfNeeded() {
        if addWordView.refreshControl.isRefreshing {
            addWordView.refreshControl.endRefreshing()
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
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
        cell.configure(word: "\(data.word): \(data.meaning)", example: data.example)
        return cell
    }
}

extension AddWordViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
