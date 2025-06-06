//
//  QuizStatusView.swift
//  WordPalette
//
//  Created by 박주성 on 5/22/25.
//

import UIKit
import Then
import SnapKit
import RxRelay

final class QuizStatusView: UIView {
    
    // MARK: - Action
    
    enum Action {
        case remainingWordZero
        case correctMilestoneReached
        case incorrectMilestoneReached
    }
    
    // MARK: - Properties
    
    let action = PublishRelay<Action>()
    
    // MARK: - UI Components
    
    /// 남은 단어 수
    private let remainingWordCountLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 24)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    /// 남은 단어 타이틀
    private let remainingWordTitleLabel = UILabel().then {
        $0.text = "남은 단어"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray
        $0.textAlignment = .center
    }
    
    /// 맞춘 단어 수
    private let correctWordCountLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 24)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    /// 맞춘 단어 타이틀
    private let correctWordTitleLabel = UILabel().then {
        $0.text = "맞춘 단어"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray
        $0.textAlignment = .center
    }
    
    /// 틀린 단어 수
    private let incorrectWordCountLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 24)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    /// 틀린 단어 타이틀
    private let incorrectWordTitleLabel = UILabel().then {
        $0.text = "틀린 단어"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray
        $0.textAlignment = .center
    }
    
    /// 남은 단어 수직 스택뷰
    private lazy var remainingStatStack = UIStackView(arrangedSubviews: [
        remainingWordCountLabel,
        remainingWordTitleLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    /// 맞춘 단어 수직 스택뷰
    private lazy var correctStatStack = UIStackView(arrangedSubviews: [
        correctWordCountLabel,
        correctWordTitleLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    /// 틀린 단어 수직 스택뷰
    private lazy var incorrectStatStack = UIStackView(arrangedSubviews: [
        incorrectWordCountLabel,
        incorrectWordTitleLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    /// 전체 수평 스택
    private lazy var quizSummaryStack = UIStackView(arrangedSubviews: [
        remainingStatStack,
        correctStatStack,
        incorrectStatStack
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.distribution = .fillEqually
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
        remainingWordCountLabel.text = "\(quizInfo.words.count)"
        correctWordCountLabel.text = "\(quizInfo.correctCount)"
        incorrectWordCountLabel.text = "\(quizInfo.incorrectCount)"
    }
    
    /// 퀴즈를 풀고 난 후 UI 업데이트
    func updateAfterAnswer(with isCorrect: Bool) {
        let remaining = max(0, (Int(remainingWordCountLabel.text ?? "") ?? 0) - 1)
        var correct = Int(correctWordCountLabel.text ?? "") ?? 0
        var incorrect = Int(incorrectWordCountLabel.text ?? "") ?? 0

        // 정답/오답 카운트 업데이트
        if isCorrect {
            correct += 1
            correctWordCountLabel.text = "\(correct)"
        } else {
            incorrect += 1
            incorrectWordCountLabel.text = "\(incorrect)"
        }

        // 남은 단어 수 업데이트
        remainingWordCountLabel.text = "\(remaining)"

        // 액션 발생 조건 처리
        switch remaining {
        case 0:
            action.accept(.remainingWordZero)
        default:
            if isCorrect, correct % 3 == 0 {
                action.accept(.correctMilestoneReached)
            }
            if !isCorrect, incorrect % 3 == 0 {
                action.accept(.incorrectMilestoneReached)
            }
        }
    }
}

// MARK: - Configure

private extension QuizStatusView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        backgroundColor = .white
    }
    
    func setHierarchy() {
        addSubview(quizSummaryStack)
    }
    
    func setConstraints() {
        quizSummaryStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
