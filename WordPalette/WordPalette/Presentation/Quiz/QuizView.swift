//
//  QuizView.swift
//  WordPalette
//
//  Created by 박주성 on 5/22/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxRelay

final class QuizView: UIView {
    
    // MARK: - Action
    
    enum Action {
        case didSwipe(Bool)
        case didFinishQuiz
        case didSelectLevel(Level)
    }
    
    // MARK: - Properties
    
    let action = PublishRelay<Action>()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    /// 퀴즈 화면 상단 타이틀 레이블 ("퀴즈 시간")
    private let titleLabel = UILabel().then {
        $0.text = "퀴즈 시간"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 32, weight: .bold)
    }
    
    /// 단어 카드 뷰 (퀴즈 문제 출제 영역)
    private let quizCardStackView = QuizCardStackView()
    
    /// 사용자가 "외웠어요!" 선택 시 누르는 버튼 (정답 처리용)
    private let correctButton = UIButton().then {
        $0.setTitle("← 외웠어요 !", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.setTitleColor(.gray, for: .normal)
        $0.contentHorizontalAlignment = .left
    }
    
    /// 사용자가 "못 외웠어요" 선택 시 누르는 버튼 (오답 처리용)
    private let incorrectButton = UIButton().then {
        $0.setTitle("못 외웠어요 →", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.setTitleColor(.gray, for: .normal)
        $0.contentHorizontalAlignment = .right
    }
    
    /// 수평 스택뷰 (정답, 오답)
    private lazy var choiceStackView = UIStackView(
        arrangedSubviews: [
            correctButton,
            incorrectButton
        ]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.distribution = .fillEqually
    }
    
    private let quizStatusView = QuizStatusView()
    
    private let levelButtonView = LevelButtonView().then {
        $0.updateButtonSelection(selected: .beginner)
    }
    
    // MARK: - Initailizer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Update
    
    /// 초기 UI 업데이트
    func update(with quizInfo: QuizViewInfo) {
        updateQuizCardStackView(with: quizInfo.words)
        quizStatusView.update(with: quizInfo)
    }
    
    /// 퀴즈를 풀고 난 후 UI 업데이트
    func updateAfterAnswer(with isCorrect: Bool) {
        quizStatusView.updateAfterAnswer(with: isCorrect)
    }
    
    func updateQuizCardStackView(with words: [WordEntity]) {
        let cards = words.map {
            let card = QuizCardView()
            card.update(word: $0.word, example: $0.example, meaning: $0.meaning)
            return card
        }
        quizCardStackView.setCards(cards)
    }
    
    func updateLevelButtons(with level: Level) {
        levelButtonView.updateButtonSelection(selected: level)
    }

}

// MARK: - Configure

private extension QuizView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }
    
    func setAttributes() {
        backgroundColor = .white
    }
    
    func setHierarchy() {
        [
            titleLabel,
            quizCardStackView,
            choiceStackView,
            quizStatusView,
            levelButtonView
        ].forEach { addSubview($0) }
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview()
        }
        
        quizCardStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(50)
            $0.height.equalTo(quizCardStackView.snp.width).multipliedBy(1.6).priority(.low)
        }
        
        choiceStackView.snp.makeConstraints {
            $0.top.equalTo(quizCardStackView.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        quizStatusView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(choiceStackView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        levelButtonView.snp.makeConstraints {
            $0.top.equalTo(quizStatusView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(32)
        }
    }
    
    func setBindings() {
        Observable.merge(
            correctButton.rx.tap.map { true },
            incorrectButton.rx.tap.map { false }
        )
        .throttle(.milliseconds(1_000), scheduler: MainScheduler.instance)
        .subscribe(with: self) { owner, isCorrect in
            owner.quizCardStackView.answerTopCard(with: isCorrect)
        }
        .disposed(by: disposeBag)
        
        quizCardStackView.action
            .map { stackAction -> QuizView.Action in
                switch stackAction {
                case .didSwipe(let isCorrect):
                    return .didSwipe(isCorrect)
                case .didFinishQuiz:
                    return .didFinishQuiz
                }
            }
            .bind(to: action)
            .disposed(by: disposeBag)
        
        levelButtonView.bindButtonTapped()
            .map { QuizView.Action.didSelectLevel($0) }
            .bind(to: action)
            .disposed(by: disposeBag)
    }
}
