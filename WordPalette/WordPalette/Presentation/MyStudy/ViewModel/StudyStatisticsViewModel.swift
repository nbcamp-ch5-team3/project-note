//
//  StudyStatisticsViewModel.swift
//  WordPalette
//
//  Created by Quarang on 5/21/25.
//

import Foundation

// MARK: - 나의 학습 통계 로직 처리를 위한 View Model
final class StudyStatisticsViewModel {
    
    private let useCase: StudyHistoryUseCase
    
    init(useCase: StudyHistoryUseCase) {
        self.useCase = useCase
    }
}
