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
    
    // 임시 DI (나중에 DI컨테이너로 대체)
    private let viewModel: AddWordViewModel = {
        let localDataSource = WordLocalDataSource()
        let coreDataManager = CoreDataManager()
        let unsolvedRepo = UnsolvedWordRepositoryImpl(localDataSource: localDataSource, coredataManager: coreDataManager)
        let useCase = AddWordUseCaseImpl(repository: unsolvedRepo)
        return AddWordViewModel(useCase: useCase)
    }()
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let addWordView = AddWordView()
    private var addedWordIndexPath: IndexPath?
    private let selectedLevel: Level
    
    // MARK: - Input Subjects
    private let viewWillAppearSubject = PublishSubject<Void>()
    private let refreshSubject = PublishSubject<Void>()
    private let searchTextSubject = BehaviorSubject<String>(value: "")
    private let addWordTapSubject = PublishSubject<WordEntity>()
    private let addCustomWordTapSubject = PublishSubject<(en: String, ko: String, example: String?)>()
    private let selectedLevelSubject: BehaviorRelay<Level>

    // MARK: - Output Properties
    private var words: [WordEntity] = []
    
    // MARK: - Init
    init(selectedLevel: Level) {
        self.selectedLevel = selectedLevel
        self.selectedLevelSubject = BehaviorRelay<Level>(value: selectedLevel)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Life Cycle
    override func loadView() {
        self.view = addWordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewCell()
        setupDelegate()
        setTitleByLevel()
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
    
    func setTitleByLevel() {
        title = "\(selectedLevel.rawValue) 단어 추가"
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
    /// Input 이벤트 바인딩
    private func bindInput() {
        bindFloatingButton()
        bindSearchBar()
        bindRefreshControl()
    }
    
    // MARK: - Output Binding
    /// Output 이벤트 바인딩
    private func bindOutput(_ output: AddWordViewModel.Output) {
        bindWordsOutput(output.words)
        bindAddResultOutput(output.addResult)
        bindAlertOutput(output.showAlert)
    }
    
    // MARK: - Individual Input Bindings
    /// 플로팅 버튼 탭 바인딩
    private func bindFloatingButton() {
        addWordView.floatingButton.rx.tap
            .bind(with: self, onNext: presentModal)
            .disposed(by: disposeBag)
    }
    
    /// 검색바 텍스트 바인딩
    private func bindSearchBar() {
        addWordView.searchBar.rx.text.orEmpty
            .bind(to: searchTextSubject)
            .disposed(by: disposeBag)
    }
    
    /// 새로고침 컨트롤 바인딩
    private func bindRefreshControl() {
        addWordView.refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: refreshSubject)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Individual Output Bindings
    /// 단어 리스트 바인딩
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
    
    /// 단어 추가 결과 바이딩
    private func bindAddResultOutput(_ addResult: Observable<AddWordResult>) {
        addResult
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, result in
                switch result {
                case .success(let savedWord):
                    // 전체 새로고침 대신, 현재 저장한 셀만 업데이트
                    if let selectedIndexPath = owner.addedWordIndexPath {
                        owner.words[selectedIndexPath.row] = savedWord
                        owner.addWordView.tableView.reloadRows(at: [selectedIndexPath], with: .fade)
                        owner.addedWordIndexPath = nil // 초기화
                    } else {
                        // 커스텀 단어 추가의 경우 전체 새로고침
                        owner.refreshSubject.onNext(())
                    }
                case .failure:
                    // 실패는 Alert로 처리됨
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    /// Alert 메시지 바인딩
    private func bindAlertOutput(_ showAlert: Observable<String>) {
        showAlert
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, message in
                owner.showAlert(message: message)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Modal Presentation
    /// 단어 추가 모달 표시
    private func presentModal(_ owner: AddWordViewController, _ element: Void) {
        let modal = AddWordModalViewController()
        modal.modalPresentationStyle = .overFullScreen
        
        // 모달에서 저장 버튼 탭 시 처리
        modal.onSaveButtonTap = { [weak self] en, ko, example in
            self?.addCustomWordTapSubject.onNext((en: en, ko: ko, example: example))
        }
        
        // 중복 체크 콜백 설정
        modal.onCheckDuplicate = { [weak self] word, completion in
            self?.checkDuplicate(word: word, completion: completion)
        }
        
        present(modal, animated: true)
    }
    
    private func checkDuplicate(word: String, completion: @escaping (Bool, Level?) -> Void) {
        viewModel.checkDuplicateOnly(word: word)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { isDuplicate, level in
                completion(isDuplicate, level)
            }, onFailure: { _ in
                completion(false, nil) // 에러 시 중복 없음으로 처리
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helper Methods
    /// 새로고침 종료 처리
    private func endRefreshingIfNeeded() {
        if addWordView.refreshControl.isRefreshing {
            addWordView.refreshControl.endRefreshing()
        }
    }
    
    /// Alert 표시
    private func showAlert(message: String) {
        // 이미 Alert가 표시 중인지 확인 (Alert 중복 방지)
        if presentedViewController != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.showAlert(message: message)
            }
            return
        }
        
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    /// 단어 저장 확인 Alert 표시
    private func showAddWordAlert(word: WordEntity) {
        let alert = UIAlertController(
            title: "내 단어장에 저장",
            message: "\(word.word)을(를) 내 단어장에 저장하시겠습니까?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            self?.addWordTapSubject.onNext(word)
        }))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension AddWordViewController: UITableViewDataSource, UITableViewDelegate {
    /// 테이블뷰 셀 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    /// 테이블뷰 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewWordCell.id, for: indexPath) as? TableViewWordCell else {
            return UITableViewCell()
        }
        let data = words[indexPath.row]
        cell.configure(word: "\(data.word): \(data.meaning)", example: data.example)
        
        // source에 따라 UI 분기
        switch data.source {
        case .database:
            cell.publicAddButton.isHidden = true
            cell.publicContainerView.backgroundColor = .customMango
        case .json:
            cell.publicAddButton.isHidden = false
            cell.publicContainerView.backgroundColor = .customBanana
        }
        
        cell.addButtonTap
            .bind(with: self) { owner, _ in
                owner.addedWordIndexPath = indexPath
                owner.showAddWordAlert(word: data)
            }
            .disposed(by: cell.disposeBag)
        
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension AddWordViewController: UISearchBarDelegate {
    /// 검색 버튼 클릭 시 키보드 내림
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
