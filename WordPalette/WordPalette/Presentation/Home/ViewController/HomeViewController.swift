import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class HomeViewController: UIViewController {
    private let diContainer: DIContainer
    
    private let homeView = HomeView()

    /// Rx를 사용하기 위한 disposeBag
    private let disposeBag = DisposeBag()

    private let homeViewModel: HomeViewModel

    // MARK: - Initialize
    init(viewModel: HomeViewModel, diContainer: DIContainer) {
        self.homeViewModel = viewModel
        self.diContainer = diContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - loadView
    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBackButton()
        bindLevelButtonView()
        bindToSearchButton()
        bindCellData()
        configureRegister()
        configureDelegate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 단어 찾기 페이지에서 홈 화면으로 돌아갈 때 화면을 바로 업데이트하기 위함
        let selected = homeViewModel.selectedLevelRelay.value
        homeViewModel.selectedLevelRelay.accept(selected)
    }

    // MARK: - bind
    private func bindLevelButtonView() {
        homeView.levelButtonView
            .bindButtonTapped()
            .bind(to: homeViewModel.selectedLevelRelay) // ViewModel에 상태 전달
            .disposed(by: disposeBag)

        // 선택 상태 변경 시 배경색 변경
        homeViewModel.selectedLevelRelay
            .asObservable() // VC에서는 구독만 하고 상태 변경은 VM에서 하도록
            .bind(with: self) { owner, selected in
                owner.homeView.levelButtonView.updateButtonSelection(selected: selected)
            }
            .disposed(by: disposeBag)

        // Cell Data 전체 삭제
        homeView.deleteAllButton.rx.tap
            .bind(with: self) { owner, _ in
                let selectedLevel = owner.homeViewModel.selectedLevelRelay.value
                let wordList = owner.homeViewModel.wordListRelay.value

                if wordList.isEmpty {
                    owner.showEmptyWordAlert(for: selectedLevel)
                } else {
                    owner.showAlertDeleteAll(for: selectedLevel) {
                        owner.homeViewModel.deleteAllWords()
                    }
                }
            }
            .disposed(by: disposeBag)
    }

    /// 단어 검색 페이지로 넘어가는 메서드
    private func bindToSearchButton() {
        zip(homeView.levelSearchButtons, homeView.levels).forEach { button, level in
            button.rx.tap
                .bind(with: self) { owner, _ in
                    // VM 상태 변경
                    owner.homeViewModel.selectedLevelRelay.accept(level)
                    // 버튼 UI 즉시 업데이트
                    owner.homeView.levelButtonView.updateButtonSelection(selected: level)

                    let addWordVC = self.diContainer.makeAddWordViewController(selectedLevel: level) // 레벨별 검색 페이지로 이동
                    owner.navigationController?.pushViewController(addWordVC, animated: true)
                }
                .disposed(by: disposeBag)
        }
    }

    /// Cell별 Data 바인딩 메서드
    private func bindCellData() {
        homeViewModel.wordListRelay
            .bind(to: homeView.myWordTableView.rx.items(
                cellIdentifier: TableViewWordCell.id,
                cellType: TableViewWordCell.self)
            ) { row, word, cell in
                cell.configure(word: "\(word.word): \(word.meaning)", example: word.example)
                cell.publicAddButton.isHidden = true
                cell.publicContainerView.backgroundColor = .customMango
            }
            .disposed(by: disposeBag)
    }

    // MARK: - register & delegate
    /// tableVIew Cell 연결하는 메서드
    private func configureRegister() {
        homeView.myWordTableView.register(TableViewWordCell.self, forCellReuseIdentifier: TableViewWordCell.id)
    }

    /// tableView의 delegate 메서드 모음
    private func configureDelegate() {
        homeView.myWordTableView.delegate = self
    }

    // MARK: - Alert
    /// 전체 삭제 시 확인 메세지 Alert
    private func showAlertDeleteAll(for level: Level, handler: @escaping () -> Void) {
        let alert = UIAlertController(title: "\(level.rawValue) 단어장을 전체 삭제하시겠습니까?", message: nil, preferredStyle: .alert)

        let confirm = UIAlertAction(title: "확인", style: .destructive) { _ in
            handler()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)

        alert.addAction(confirm)
        alert.addAction(cancel)

        present(alert, animated: true)
    }

    /// 저장된 셀이 비어있을 때 경고하는 Alert
    private func showEmptyWordAlert(for level: Level) {
        let alert = UIAlertController(title: "저장된 \(level.rawValue) 단어가 없습니다!", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }

    // MARK: - Navigation UI
    /// navigation backButton의 UI를 설정하는 메서드
    private func configureNavigationBackButton() {
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .customOrange
    }
}

// MARK: - extension: UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completion in
            guard let self = self else { return }
            let word = self.homeViewModel.wordListRelay.value[indexPath.row]
            self.homeViewModel.deleteWord(word)
            completion(true)
        }

        delete.backgroundColor = .customOrange
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
