import UIKit
import SnapKit
import Then

final class HomeView: UIView {
    /// Level 배열
    let levels: [Level] = [.beginner, .intermediate, .advanced]

    /// 단어 추가 label
    private let addWordLabel = UILabel().then {
        $0.text = "단어 추가"
        $0.font = .systemFont(ofSize: 32, weight: .heavy)
        $0.textColor = .black
    }

    /// 레벨별로 단어를 검색해서 추가하는 페이지로 가기 위한 버튼 묶음 stackView
    private lazy var levelSearchButtonStackView = UIStackView(arrangedSubviews: levelSearchButtons).then {
        $0.axis = .horizontal
        $0.spacing = 40
        $0.distribution = .fillEqually
    }

    /// 레벨별 검색 페이지 버튼 배열 (초급, 중급, 고급)
    lazy var levelSearchButtons: [UIButton] = levels.map { level in
        let button = UIButton().then {
            $0.setTitle(level.rawValue, for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 26, weight: .heavy)
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
            $0.backgroundColor = {
                switch level {
                case .beginner: return .customBanana
                case .intermediate: return .customOrange
                case .advanced: return .customStrawBerry
                }
            }()
        }
        return button
    }

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

    /// 전체 삭제 버튼
    let deleteAllButton = UIButton().then {
        $0.setTitle("전체 삭제", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.backgroundColor = .customOrange
        $0.layer.cornerRadius = 12
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
            addWordLabel,
            levelSearchButtonStackView,
            myWordLabel,
            levelButtonView,
            myWordTableView,
            deleteAllButton
        ].forEach { addSubview($0) }

        addWordLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(24)
        }

        levelSearchButtonStackView.snp.makeConstraints {
            $0.top.equalTo(addWordLabel.snp.bottom).offset(18)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(levelSearchButtonStackView.snp.width).dividedBy(4)
        }

        myWordLabel.snp.makeConstraints {
            $0.top.equalTo(levelSearchButtonStackView.snp.bottom).offset(24)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(24)
        }

        levelButtonView.snp.makeConstraints {
            $0.top.equalTo(myWordLabel.snp.bottom).offset(18)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(32)
        }

        myWordTableView.snp.makeConstraints {
            $0.top.equalTo(levelButtonView.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(deleteAllButton.snp.top).offset(-18)
        }

        deleteAllButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(55)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-18)
        }
    }
}
