import UIKit
import SnapKit
import Then

final class LevelButtonView: UIView {
    /// Level 배열
    private let levels: [Level] = [.beginner, .intermediate, .advanced]

    /// 선택된 버튼의 초기값은 초급 버튼
    private var selectedLevel: Level = .beginner {
        didSet {
            updateButtonSelection() // 버튼 상태 갱신
        }
    }

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
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
            $0.tag = levelIndex(level: level)
            $0.addTarget(self, action: #selector(levelButtonTapped), for: .touchUpInside)
        }
        return button
    }

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        updateButtonSelection()
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

    /// tag로 Levels에서 어떤 레벨인지 확인하기 위한 메서드
    private func levelIndex(level: Level) -> Int {
        switch level {
        case .beginner: return 0
        case .intermediate: return 1
        case .advanced: return 2
        }
    }

    /// 버튼의 배경색이 선택되었을 때, 선택되지 않았을 때 분리하기 위한 메서드
    private func updateButtonSelection() {
        for (index, button) in levelButtons.enumerated() {
            let level = levels[index]
            if level == selectedLevel {
                button.backgroundColor = .customMango
            } else {
                button.backgroundColor = .systemGray3
            }
        }
    }

    /// 버튼이 눌렸을 때 실행되는 메서드
    @objc private func levelButtonTapped(level: UIButton) {
        guard level.tag < levels.count else { return }
        selectedLevel = levels[level.tag]
    }
}
