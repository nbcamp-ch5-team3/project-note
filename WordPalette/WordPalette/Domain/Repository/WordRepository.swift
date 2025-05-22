//
//  WordRepository.swift
//  WordPalette
//
//  Created by iOS study on 5/21/25.
//

import RxSwift

protocol WordRepository {
    func searchWord(keyword: String, level: Level) -> Single<[WordEntity]>
}
