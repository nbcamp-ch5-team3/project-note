import UIKit
import RxSwift
import RxCocoa

final class HomeViewModel {
    /// 선택된 버튼의 초기값은 초급 버튼
    let selectedLevelRelay = BehaviorRelay<Level>(value: .beginner)
    /// 내 단어장 BehaviorRelay
    let wordListRelay = BehaviorRelay<[WordEntity]>(value: [])

    private let disposeBag = DisposeBag()
    private let unsolvedMyWordUseCase: UnsolvedMyWordUseCase

    init(unsolvedMyWordUseCase: UnsolvedMyWordUseCase) {
        self.unsolvedMyWordUseCase = unsolvedMyWordUseCase
    }

    // MARK: - Mock Data (머지 후 브랜치 파서 수정 예정)
    private let mockAllWordsRelay = BehaviorRelay<[WordEntity]>(value: [
        WordEntity(id: UUID(), word: "Apple", meaning: "사과", example: "I ate an apple.", level: .beginner),
        WordEntity(id: UUID(), word: "Run", meaning: "달리다", example: "He runs fast.", level: .beginner),
        WordEntity(id: UUID(), word: "Negotiate", meaning: "협상하다", example: "We negotiated.", level: .intermediate),
        WordEntity(id: UUID(), word: "Ponder", meaning: "숙고하다", example: "She pondered.", level: .advanced)
    ])

    func bindMockFiltering() {
        Observable.combineLatest(
            selectedLevelRelay,
            mockAllWordsRelay
        )
        .map { selected, allWords in
            allWords.filter { $0.level == selected }
        }
        .bind(to: wordListRelay)
        .disposed(by: disposeBag)
    }

    // 전체 삭제
    func deleteMockWord(_ word: WordEntity) {
        var current = mockAllWordsRelay.value
        current.removeAll { $0.id == word.id }
        mockAllWordsRelay.accept(current)
    }

    // 개별 삭제
    func deleteAllMockWords() {
        let currentLevel = selectedLevelRelay.value
        let updated = mockAllWordsRelay.value.filter { $0.level != currentLevel }
        mockAllWordsRelay.accept(updated)
    }
}
