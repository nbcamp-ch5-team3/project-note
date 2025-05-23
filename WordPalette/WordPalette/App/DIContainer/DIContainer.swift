//
//  DIContainer.swift
//  WordPalette
//
//  Created by Quarang on 5/23/25.
//

import Foundation

final class DIContainer {
    
    // MARK: - 데이터 소스 및 매니쟈
    
    /// Json 파일 데이터 소스
    private let localDataSource = WordLocalDataSource()
    /// CoreData CRUD 매니저
    private let coreDataManager = CoreDataManager()
    
    // MARK: - 레포지토리
    
    /// 아직 풀지 않은 문제를 핸들링할 레포지토리
    private var makeUnsolvedRepository: UnsolvedWordRepository {
        UnsolvedWordRepositoryImpl(localDataSource: localDataSource, coredataManager: coreDataManager)
    }
    
    /// 이미 푼 문제를 핸들링할 레포지토리
    private var makeSoveldRepository: SolvedWordRepository {
        SolvedWordRepositoryImpl(coredataManager: coreDataManager)
    }
    
    /// 유저 정보 요청 레포지토리
    private var makeUserRepository: UserRepository {
        UserRepositoryImpl(coredataManager: coreDataManager)
    }
    
//    ///
//    var makeAddWordRepository: AddWordRepository {
//        AddWordRepositoryImpl(localDataSource: localDataSource, unsolvedWordRepository: unsolvedRepository)
//    }
    
    // MARK: - 유즈케이스
    
    /// 학습 기록 및 통계 유즈케이스
    private var makeStudyHistoryUseCase: StudyHistoryUseCase {
        StudyHistoryUseCaseImpl(userRepository: makeUserRepository, solvedRepository: makeSoveldRepository)
    }
    
//    ///
//    var makeAddWordUseCase: AddWordUseCase {
//        AddWordUseCaseImpl(repository: makeAddWordRepository)
//    }
    
    // MARK: - ViewModel
    
    /// 나의 학습 기록 ViewModel
    private var makeStudyHistoryViewModel: StudyHistoryViewModel {
        StudyHistoryViewModel(useCase: makeStudyHistoryUseCase)
    }
    
    /// 학습 기록에 따른 통계 ViewModel
    private var makeStudyStatisticsViewModel: StudyStatisticsViewModel {
        StudyStatisticsViewModel(useCase: makeStudyHistoryUseCase)
    }
    
    private var makeQuizViewModel: QuizViewModel {
        QuizViewModel()
    }
    
//    ///
//    var makeAddWordViewModel: AddWordViewModel {
//        AddWordViewModel(useCase: makeAddWordUseCase)
//    }
    
    
    // MARK: - ViewController
    
    /// 홈 ViewController
    public func makeHomeViewController() -> HomeViewController {
        HomeViewController()
    }
    
    /// 퀴즈 ViewController
    public func makeQuizViewController() -> QuizViewController {
        QuizViewController(viewModel: makeQuizViewModel)
    }
    
    /// 나의 학습 기록 ViewController
    public func makeStudyHistoryViewContoller() -> StudyHistoryViewController {
        StudyHistoryViewController(viewModel: makeStudyHistoryViewModel, DIContainer: self)
    }
    
    /// 학습 기록에 따른 통계 ViewController
    public func makeStudyStatisticsViewContoller(studyHistory: StudyHistory) -> StudyStatisticsViewController {
        StudyStatisticsViewController(studyHistory: studyHistory, viewModel: makeStudyStatisticsViewModel)
    }
}
