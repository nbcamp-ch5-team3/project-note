import Foundation
import RxSwift

protocol UnsolvedMyWordUseCase {
    func fetchWords(by level: Level) -> Single<[WordEntity]>
    func deleteWord(id: UUID) -> Single<Bool>
    func deleteAllWords(by level: Level) -> Single<Bool>
}
