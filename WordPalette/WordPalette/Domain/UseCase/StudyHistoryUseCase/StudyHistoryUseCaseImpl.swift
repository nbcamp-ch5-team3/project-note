//
//  StudyHistoryUseCaseImpl.swift
//  WordPalette
//
//  Created by Quarang on 5/23/25.
//

import Foundation
import RxSwift

// MARK: - 나의 학습 기록 관련 유즈케이스 구현체
final class StudyHistoryUseCaseImpl: StudyHistoryUseCase {
    
    private let userRepository: UserRepository
    private let solvedRepository: SolvedWordRepository
    
    init(userRepository: UserRepository, solvedRepository: SolvedWordRepository) {
        self.userRepository = userRepository
        self.solvedRepository = solvedRepository
    }
    
    /// 나의 학습기록 화면 appearing 될 때 학습기록 데이터 요청
    func fetchStudyHistory() -> Single<UserData>{
        return userRepository.fetchUserData()
    }
    
    /// 캘린더에서 날짜 선택 시 해당 날짜의 통계 기록 요청
    func fetchWords(id: UUID) -> Single<(all: [WordEntity], memos: [WordEntity], unMemos: [WordEntity])>{
        return solvedRepository.fetchWords(id: id)
            .map { words in
                let all = Array(words.reversed())
                let memos = Array(words.filter { $0.isCorrect == true }.reversed())
                let unMemos = Array(words.filter { $0.isCorrect != true }.reversed())
                return (all: all, memos: memos, unMemos: unMemos)
            }
    }
}
