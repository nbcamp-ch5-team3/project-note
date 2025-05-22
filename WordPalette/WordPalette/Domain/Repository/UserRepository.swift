//
//  UserRepository.swift
//  WordPalette
//
//  Created by 박주성 on 5/21/25.
//

import RxSwift

protocol UserRepository {
    func fetchUserData() -> Single<UserData>
}
