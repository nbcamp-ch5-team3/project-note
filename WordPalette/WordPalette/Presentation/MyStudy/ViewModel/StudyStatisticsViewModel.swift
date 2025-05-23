//
//  StudyStatisticsViewModel.swift
//  WordPalette
//
//  Created by Quarang on 5/21/25.
//

import Foundation
import RxSwift
import RxRelay

// MARK: - 나의 학습 통계 로직 처리를 위한 View Model
final class StudyStatisticsViewModel: ViewModelType {
    
    struct State {
        private(set) var actionSubject = PublishSubject<Action>()
    
        private(set) var memoStateData = BehaviorRelay<(memo: Int, unMemo:Int)>(value:(0, 0))
        private(set) var statisticData = BehaviorRelay<[WordEntity]>(value: [])
    }
    
    enum Action {
        case viewDidLoad(id: UUID)
        case didChangedSegmentIndex(index: Int)
    }
    
    var words: [[WordEntity]] = []
    var disposeBag = DisposeBag()
    var state = State()
    
    var action: AnyObserver<Action> {
        state.actionSubject.asObserver()
    }
    
    private let useCase: StudyHistoryUseCase
    
    init(useCase: StudyHistoryUseCase) {
        self.useCase = useCase
        bind()
    }
    
    func bind() {
        state.actionSubject
            .subscribe(with: self) { owner, action in
                switch action {
                case let .viewDidLoad(id): owner.fetchStatisticsData(id: id)
                case let .didChangedSegmentIndex(index): owner.setWordList(index: index)
                }
            }
            .disposed(by: disposeBag)
    }
    
    /// 해당 날짜에 학습한 단어 리스트 정보 요청
    private func fetchStatisticsData(id: UUID) {
        useCase.fetchWords(id: id)
            .subscribe(with: self) { owner, words in
                let (all, memos, unMemos) = words
                
                // 모든 단어 리스트 일단 추가
                owner.state.statisticData.accept(all)
                
                // 모두/암기/미암기 순으로 저장 (필요할 떄마다 statisticData에 저장)
                [all, memos, unMemos].forEach { owner.words.append($0) }
                
                // 암기/미암기 수량 저장
                owner.state.memoStateData.accept((memos.count, unMemos.count))
            }
            .disposed(by: disposeBag)
    }
    
    /// 단어 리스트 저장
    private func setWordList(index: Int) {
        state.statisticData.accept(words[index])
    }
}
