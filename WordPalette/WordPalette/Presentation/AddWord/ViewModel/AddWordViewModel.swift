//
//  AddWordViewModel.swift
//  WordPalette
//
//  Created by iOS study on 5/23/25.
//

import UIKit
import RxSwift

// 단순화한 결과 타입
enum AddWordResult {
    case success(WordEntity)
    case failure(String)
}

final class AddWordViewModel {
    
    // MARK: - Input
    struct Input {
        let viewWillAppear: Observable<Void>
        let refreshTrigger: Observable<Void>
        let searchText: Observable<String>
        let addWordTap: Observable<WordEntity>
        let addCustomWordTap: Observable<(en: String, ko: String, example: String?)>
        let selectedLevel: Observable<Level>
    }
    
    // MARK: - Output
    struct Output {
        let words: Observable<[WordEntity]>
        let addResult: Observable<AddWordResult>
        let showAlert: Observable<String>
    }
    
    // MARK: - Output Subjects
    private let wordsSubject = BehaviorSubject<[WordEntity]>(value: [])
    private let addResultSubject = PublishSubject<AddWordResult>()
    private let showAlertSubject = PublishSubject<String>()
    
    // MARK: - Properties
    private let useCase: AddWordUseCase
    private let disposeBag = DisposeBag()
    private var currentLevel: Level = .beginner
    
    // MARK: - Init
    init(useCase: AddWordUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    func transform(input: Input) -> Output {
        bindLevelAndAppear(input: input)
        bindRefresh(input: input)
        bindSearch(input: input)
        bindAddWord(input: input)
        bindAddCustomWord(input: input)
        bindAlert()
        
        return Output(
            words: wordsSubject.asObservable(),
            addResult: addResultSubject.asObservable(),
            showAlert: showAlertSubject.asObservable()
        )
    }
    
    /// 중복 체크 (모달용)
    func checkDuplicateOnly(word: String) -> Single<(Bool, Level?)> {
        return useCase.checkDuplicate(word: word)
    }
    
    // 1. 레벨 선택/화면 진입 시 단어 로드
    private func bindLevelAndAppear(input: Input) {
        Observable.combineLatest(input.selectedLevel, input.viewWillAppear.startWith(()))
            .flatMapLatest { [weak self] level, _ -> Observable<[WordEntity]> in
                guard let self = self else { return .empty() }
                self.currentLevel = level
                return self.loadRandomWords()
            }
            .bind(to: wordsSubject)
            .disposed(by: disposeBag)
    }
    
    // 2. Pull-to-Refresh
    private func bindRefresh(input: Input) {
        input.refreshTrigger
            .flatMapLatest { [weak self] _ -> Observable<[WordEntity]> in
                guard let self = self else { return .empty() }
                return self.loadRandomWords()
            }
            .bind(to: wordsSubject)
            .disposed(by: disposeBag)
    }
    
    // 3. 검색
    private func bindSearch(input: Input) {
        input.searchText
            .distinctUntilChanged()
            .flatMapLatest { [weak self] keyword -> Observable<[WordEntity]> in
                guard let self = self else { return .empty() }
                return self.searchWords(keyword: keyword)
            }
            .bind(to: wordsSubject)
            .disposed(by: disposeBag)
    }
    
    // 4. +버튼: 단어 저장 + 중복 체크(DB만)
    private func bindAddWord(input: Input) {
        input.addWordTap
            .flatMapLatest { [weak self] word -> Observable<AddWordResult> in
                guard let self = self else { return .empty() }
                return self.addJsonWordToDatabase(word)
            }
            .bind(to: addResultSubject)
            .disposed(by: disposeBag)
        
    }
    
    // 5. 모달에서 직접 단어 입력: 중복 체크 + 저장
    private func bindAddCustomWord(input: Input) {
        input.addCustomWordTap
            .flatMapLatest { [weak self] en, ko, example -> Observable<AddWordResult> in
                guard let self = self else { return .empty() }
                return self.addCustomWord(en: en, ko: ko, example: example)
            }
            .bind(to: addResultSubject)
            .disposed(by: disposeBag)
    }
    
    // 6. 결과에 따라 Alert 출력
    private func bindAlert() {
        addResultSubject
            .compactMap { result in
                switch result {
                case .success: return "단어가 저장되었습니다."
                case .failure(let message): return message
                }
            }
            .bind(to: showAlertSubject)
            .disposed(by: disposeBag)
    }
}

// MARK: - Private Methods
private extension AddWordViewModel {
    /// 랜덤 단어 20개 로드
    func loadRandomWords() -> Observable<[WordEntity]> {
        return useCase.fetchWords(level: currentLevel, keyword: nil, limit: 20)
            .asObservable()
            .observe(on: MainScheduler.instance)
    }
    
    /// 단어 검색
    func searchWords(keyword: String) -> Observable<[WordEntity]> {
        let searchKeyword = keyword.isEmpty ? nil : keyword
        return useCase.fetchWords(level: currentLevel, keyword: searchKeyword, limit: nil)
            .asObservable()
            .observe(on: MainScheduler.instance)
    }
    
    /// JSON 단어를 DB로 저장 (+버튼)
    func addJsonWordToDatabase(_ word: WordEntity) -> Observable<AddWordResult> {
        print("[단어 추가 시도] \(word.word)")
        
        return useCase.saveWord(word, convertToDatabase: true)
            .map { savedWord in
                print("[저장 성공] \(savedWord.word)")
                return .success(savedWord)
            }
            .catch { error in
                print("[저장 실패] \(word.word): \(error.localizedDescription)")
                return .just(.failure("이미 등록된 단어이거나 저장에 실패했습니다."))
            }
            .asObservable()
    }
    
    /// 커스텀 단어 추가
    func addCustomWord(en: String, ko: String, example: String?) -> Observable<AddWordResult> {
        print("[커스텀 단어 추가 시도] \(en): \(ko)")
        
        let word = WordEntity(
            id: UUID(),
            word: en.trimmingCharacters(in: .whitespacesAndNewlines),
            meaning: ko.trimmingCharacters(in: .whitespacesAndNewlines),
            example: example ?? "",
            level: currentLevel,
            isCorrect: nil,
            source: .database
        )
        
        return useCase.saveWord(word, convertToDatabase: false)
            .map { savedWord in
                print("[커스텀 저장 성공] \(savedWord.word)")
                return .success(savedWord)
            }
            .catch { error in
                print("[커스텀 저장 실패] \(word.word): \(error.localizedDescription)")
                return .just(.failure("저장에 실패했습니다. 다시 시도해 주세요."))
            }
            .asObservable()
    }
}
