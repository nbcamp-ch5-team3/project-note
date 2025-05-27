import UIKit
import SnapKit
import Then

final class HomeView: UIView {
    /// Level 배열
    let levels: [Level] = [.beginner, .intermediate, .advanced]

    /// 내 단어장 label
    private let myWordLabel = UILabel().then {
        $0.text = "내 단어장"
        $0.font = .systemFont(ofSize: 32, weight: .heavy)
        $0.textColor = .black
    }

    /// 선택된 버튼만 배경색이 바뀌는 레벨별 버튼
    let levelButtonView = LevelButtonView()

    /// 내 단어장 목록을 보여주는 테이블 뷰
    let myWordTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
    }

    /// 홈 화면 버튼 묶음 stackView
    private lazy var homeButtonStackView = UIStackView(arrangedSubviews: [toSearchWordButton, deleteAllButton]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }

    /// 단어 추가 페이지로 넘어가는 버튼
    let toSearchWordButton = UIButton().then {
        $0.setTitle("단어 추가", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.backgroundColor = .customOrange
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }

    /// 전체 삭제 버튼
    let deleteAllButton = UIButton().then {
        $0.setTitle("전체 삭제", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.backgroundColor = .systemGray
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }

    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Constraints
    private func configureUI() {
        backgroundColor = .white

        [
            myWordLabel,
            levelButtonView,
            myWordTableView,
            homeButtonStackView
        ].forEach { addSubview($0) }

        myWordLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(24)
        }

        levelButtonView.snp.makeConstraints {
            $0.top.equalTo(myWordLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(32)
        }

        myWordTableView.snp.makeConstraints {
            $0.top.equalTo(levelButtonView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(deleteAllButton.snp.top).offset(-16)
        }

        homeButtonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(54)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-10)
        }
    }
}
