//
//  StudyHistoryUseCase.swift
//  WordPalette
//
//  Created by Quarang on 5/21/25.
//
import RxSwift
import Foundation

// MARK: - 나의 학습 기록 관련 유즈케이스
protocol StudyHistoryUseCase {
    
    /// 나의 학습기록 화면 appearing 될 때 학습기록 데이터 요청
    func fetchStudyHistory() -> Single<UserData>
    
    /// 캘린더에서 날짜 선택 시 해당 날짜의 통계 기록 요청
    func fetchWords(id: UUID) -> Single<(all: [WordEntity], memos: [WordEntity], unMemos: [WordEntity])>
}
