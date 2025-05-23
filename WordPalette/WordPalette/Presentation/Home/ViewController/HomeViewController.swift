import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    private let homeView = HomeView()
    // tabelView 파일 만들어서 배치할 예정

    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

