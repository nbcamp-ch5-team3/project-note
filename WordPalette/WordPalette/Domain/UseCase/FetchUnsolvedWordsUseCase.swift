//
//  FetchUnsolvedWordsUseCase.swift
//  WordPalette
//
//  Created by 박주성 on 5/26/25.
//

import Foundation
import RxSwift

final class FetchUnsolvedWordsUseCase {
    
    private let repository: UnsolvedWordRepository
    
    init(repository: UnsolvedWordRepository) {
        self.repository = repository
    }
    
    func execute(for level: Level) -> Single<[WordEntity]> {
        repository.fetchWords(for: level)
    }
}
