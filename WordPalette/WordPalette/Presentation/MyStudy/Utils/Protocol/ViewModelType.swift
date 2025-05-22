//
//  ViewModelType.swift
//  WordPalette
//
//  Created by Quarang on 5/22/25.
//

import RxSwift

// MARK: - 뷰 모델에 일관적으로 사용할 수 있는 타임
protocol ViewModelType {
    
    /// Model - 상태값
    associatedtype State
    
    /// 유저 인터렉션 액션
    associatedtype Action
    
    /// 상태값 인스턴스
    var state: State { get }
    
    /// 액션을 Observer로 변경해주는 연산 프로퍼티
    var action:AnyObserver<Action> { get }
    
    /// disposeBag - 메모리관리
    var disposeBag: DisposeBag { get }
    
    /// 바인딩 메서드
    func bind()
}
