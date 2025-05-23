import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class HomeViewController: UIViewController {
    private let homeView = HomeView()
    // tabelView 파일 만들어서 배치할 예정

    /// Rx를 사용하기 위한 disposeBag
    private let disposeBag = DisposeBag()

    private let homeViewModel = HomeViewModel()

    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindLevelButtonView()
    }

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
            }.disposed(by: disposeBag)
    }
}

