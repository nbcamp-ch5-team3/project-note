import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class LevelButtonView: UIView {
    /// Level 배열
    private let levels: [Level] = [.beginner, .intermediate, .advanced]

    /// 레벨별 버튼을 모아놓은 스택 뷰
    private lazy var levelButtonStackView = UIStackView(arrangedSubviews: levelButtons).then {
        $0.axis = .horizontal
        $0.spacing = 18
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }

    /// 레벨별 버튼 배열 (초급, 중급, 고급)
    private lazy var levelButtons: [UIButton] = levels.map { level in
        let button = UIButton().then {
            $0.setTitle(level.rawValue, for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }
        return button
    }

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Constraints
    private func configureUI() {
        addSubview(levelButtonStackView)

        levelButtonStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    /// 버튼의 배경색이 선택되었을 때, 선택되지 않았을 때의 배경색을 분리하기 위한 메서드
    func updateButtonSelection(selected: Level) {
        for (index, button) in levelButtons.enumerated() {
            let level = levels[index]

            if level == selected {
                switch level {
                case .beginner:
                    button.backgroundColor = .customBanana
                case .intermediate:
                    button.backgroundColor = .customOrange
                case .advanced:
                    button.backgroundColor = .customStrawBerry
                }
            } else {
                button.backgroundColor = .systemGray5
            }
        }
    }


    // 버튼이 눌렸음을 Rx로 나타내는 메서드
    func bindButtonTapped() -> Observable<Level> {
        return Observable.merge(
            zip(levelButtons, levels).map { button, level in
                button.rx.tap.map { level }
            }
        )
    }
}
