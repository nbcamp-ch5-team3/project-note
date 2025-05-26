//
//  FetchTodayStudyHistoryUseCase.swift
//  WordPalette
//
//  Created by 박주성 on 5/26/25.
//

import Foundation
import RxSwift

final class FetchTodayStudyHistoryUseCase {
    
    private let repository: SolvedWordRepository
    
    init(repository: SolvedWordRepository) {
        self.repository = repository
    }
    
    func execute() -> Observable<[WordEntity]> {
        repository.fetchTodayWords().asObservable()
    }
}
