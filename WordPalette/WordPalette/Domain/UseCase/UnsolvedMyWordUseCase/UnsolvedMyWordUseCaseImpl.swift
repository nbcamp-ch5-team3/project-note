import Foundation
import RxSwift

final class UnsolvedMyWordUseCaseImpl: UnsolvedMyWordUseCase {

    private let repository: UnsolvedWordRepository

    init(repository: UnsolvedWordRepository) {
        self.repository = repository
    }

    func fetchWords(by level: Level) -> Single<[WordEntity]> {
        repository.fetchWords(for: level)
    }

    func deleteWord(id: UUID) -> Single<Bool> {
        repository.deleteWord(by: id)
    }

    func deleteAllWords() -> Single<Bool> {
        repository.deleteAllWords()
    }
}
