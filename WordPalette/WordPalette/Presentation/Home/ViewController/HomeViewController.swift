import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    private let homeView = HomeView()
    // tabelView 파일 만들어서 배치할 예정

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(homeView)

        homeView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges).inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalToSuperview() // bottom은 임시로 
        }
    }
}

