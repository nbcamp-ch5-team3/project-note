import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class LevelButtonView: UIView {
    /// Level 배열
    private let levels: [Level] = [.beginner, .intermediate, .advanced]

    /// Rx를 사용하기 위한 disposeBag
    private let disposeBag = DisposeBag()

    /// 선택된 버튼의 초기값은 초급 버튼
    let selectedLevelRelay = BehaviorRelay<Level>(value: .beginner)

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
        }
        return button
    }

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        bindButtonTapped()
        updateButtonSelection(selected: selectedLevelRelay.value) // 초기 선택 표시
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
    private func updateButtonSelection(selected: Level) {
        for (index, button) in levelButtons.enumerated() {
            let level = levels[index]
            button.backgroundColor = (level == selected) ? .customMango : .systemGray5
        }
    }

    /// Rx로 선택된 Level에 따라 버튼 눌렸음을 바인딩하는 메서드
    private func bindButtonTapped() {
        zip(levelButtons, levels).forEach { button, level in
            button.rx.tap
                .map { level }
                .bind(with: self) { owner, selected in
                    owner.selectedLevelRelay.accept(selected)
                    owner.updateButtonSelection(selected: selected)
                }.disposed(by: disposeBag)
        }
    }
}
