import UIKit
import RxSwift
import RxCocoa

final class HomeViewModel {
    /// 선택된 버튼의 초기값은 초급 버튼
    let selectedLevelRelay = BehaviorRelay<Level>(value: .beginner)

    init() { }
}
