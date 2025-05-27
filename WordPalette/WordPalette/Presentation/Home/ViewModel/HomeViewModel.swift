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
        bindLevelSelection()
    }

    // MARK: - Data Binding
    /// 레벨별 바인드 메서드
    private func bindLevelSelection() {
        selectedLevelRelay
            .flatMapLatest { [weak self] level -> Single<[WordEntity]> in
                guard let self = self else { return .just([]) }
                return self.unsolvedMyWordUseCase.fetchWords(by: level)
            }
            .map { wordList in
                return wordList.sorted { $0.word.lowercased() < $1.word.lowercased() }
            } // 저장된 단어 오름차순 정렬
            .bind(to: wordListRelay)
            .disposed(by: disposeBag)
    }

    /// 선택된 레벨에 해당하는 단어만 전체 삭제 메서드
    func deleteAllWords() {
        unsolvedMyWordUseCase.deleteAllWords(by: selectedLevelRelay.value)
            .flatMap { [weak self] _ -> Single<[WordEntity]> in
                guard let self = self else { return .just([]) }
                return self.unsolvedMyWordUseCase.fetchWords(by: self.selectedLevelRelay.value)
            }
            .asObservable()
            .bind(to: wordListRelay)
            .disposed(by: disposeBag)
    }

    /// 개별 삭제 메서드
    func deleteWord(_ word: WordEntity) {
        unsolvedMyWordUseCase.deleteWord(id: word.id)
            .flatMap { [weak self] _ -> Single<[WordEntity]> in
                guard let self = self else { return .just([]) }
                return self.unsolvedMyWordUseCase.fetchWords(by: self.selectedLevelRelay.value)
            }
            .asObservable()
            .bind(to: wordListRelay)
            .disposed(by: disposeBag)
    }
}
