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
    private var makeSolveddRepository: SolvedWordRepository {
        SolvedWordRepositoryImpl(coredataManager: coreDataManager)
    }
    
    /// 유저 정보 요청 레포지토리
    private var makeUserRepository: UserRepository {
        UserRepositoryImpl(coredataManager: coreDataManager)
    }
    
    // MARK: - 유즈케이스
    
    /// 학습 기록 및 통계 유즈케이스
    private var makeStudyHistoryUseCase: StudyHistoryUseCase {
        StudyHistoryUseCaseImpl(userRepository: makeUserRepository, solvedRepository: makeSolveddRepository)
    }
    
    private var makeQuizUseCase: QuizUseCase {
        QuizUseCaseImpl(
            unsolvedWordRepository: makeUnsolvedRepository,
            solvedWordRepository: makeSolveddRepository
        )
    }
    
//    ///
//    var makeAddWordUseCase: AddWordUseCase {
//        AddWordUseCaseImpl(repository: makeAddWordRepository)
//    }

    /// 내 단어장 유즈케이스
    private var makeUnsolvedMyWordUseCase: UnsolvedMyWordUseCase {
        UnsolvedMyWordUseCaseImpl(repository: makeUnsolvedRepository)
    }

    /// 단어 추가 유즈케이스
    private var makeAddWordUseCase: AddWordUseCase {
        AddWordUseCaseImpl(repository: makeUnsolvedRepository)
    }
    
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
        QuizViewModel(useCase: makeQuizUseCase)
    }
    
//    ///
//    var makeAddWordViewModel: AddWordViewModel {
//        AddWordViewModel(useCase: makeAddWordUseCase)
//    }

    private var makeHomeViewModel: HomeViewModel {
        HomeViewModel(unsolvedMyWordUseCase: makeUnsolvedMyWordUseCase)
    }

    /// 단어 추가 ViewModel
    private var makeAddWordViewModel: AddWordViewModel {
        AddWordViewModel(useCase: makeAddWordUseCase)
    }

    // MARK: - ViewController
    
    /// 홈 ViewController
    public func makeHomeViewController() -> HomeViewController {
        HomeViewController(viewModel: makeHomeViewModel)
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
    
    /// 단어 추가 ViewController
    public func makeAddWordViewController(selectedLevel: Level) -> AddWordViewController {
        AddWordViewController(selectedLevel: selectedLevel, viewModel: makeAddWordViewModel)
    }
}
