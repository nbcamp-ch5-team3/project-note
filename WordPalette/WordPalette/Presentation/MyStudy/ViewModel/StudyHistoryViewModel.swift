//
//  StudyHistoryViewModel.swift
//  WordPalette
//
//  Created by Quarang on 5/21/25.
//

import Foundation
import RxSwift
import RxRelay

// MARK: - 나의 학습기록 로직 처리를 위한 View Model
final class StudyHistoryViewModel: ViewModelType {
   
    struct State {
        private(set) var actionSubject = PublishSubject<Action>()
        
        private(set) var userData = PublishRelay<UserData>()
    }
    
    enum Action {
        case viewDidAppear
    }
    
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
                case .viewDidAppear: owner.fetchUserData()
                }
            }
            .disposed(by: disposeBag)
    }
    
    /// 유저 정보 요청
    private func fetchUserData() {
        // 유저 정보는 초반에 앱을 실행하면 무조건 저장하기 때문에 불러오지 못할 일이 없음
        // 따라서 유저 정보를 요청하는 기능 자체가 에러가 날 일이 없기 때문에 Relay로 선언
        // 스트림을 유지하기 위함도 있음 에러를 방출하면 해당 스트림은 더 이상 실행되지 않기 때문에 view가 appearing되도 이벤트를 방출하지 못할 것
        useCase.fetchStudyHistory()
            .subscribe(with: self) { owner, userData in
                owner.state.userData.accept(userData)
            }
            .disposed(by: disposeBag)
            
    }
}
