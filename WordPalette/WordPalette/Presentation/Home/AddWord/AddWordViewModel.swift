//
//  AddWordViewModel.swift
//  WordPalette
//
//  Created by iOS study on 5/23/25.
//

import UIKit
import RxSwift

// 단어 저장 결과
enum AddWordResult {
    case success
    case fail
    case duplicate
    case duplicateInLevel(word: String, level: Level)
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
        
        // DB 저장 확인용 로그
        loadAndLogDBWords()
        
        return Output(
            words: wordsSubject.asObservable(),
            addResult: addResultSubject.asObservable(),
            showAlert: showAlertSubject.asObservable()
        )
    }
    
    // 중복 체크만 수행하는 public 메서드
    func checkDuplicateOnly(word: String) -> Single<(Bool, Level?)> {
        return useCase.checkDuplicate(word: word)
            .map { result in
                return (result.exists, result.level)
            }
    }
    
    // DB에 저장된 단어 로드 및 로그 출력
    private func loadAndLogDBWords() {
        useCase.fetchDBWords(level: currentLevel)
            .subscribe(onSuccess: { words in
                print("⭕️ [DB 로드] \(self.currentLevel.rawValue) 레벨 저장된 단어 수: \(words.count)개")
                words.forEach { word in
                    print("  - \(word.word): \(word.meaning)")
                }
            }, onFailure: { error in
                print("❌ [DB 로드 실패] \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    // 1. 레벨 선택/화면 진입 시 단어 로드
    private func bindLevelAndAppear(input: Input) {
        Observable
            .combineLatest(input.selectedLevel, input.viewWillAppear.startWith(()))
            .flatMapLatest { [weak self] (level, _) -> Observable<[WordEntity]> in
                guard let self = self else { return .empty() }
                self.currentLevel = level
                return self.useCase.recommendRandomWords(level: level).asObservable()
            }
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: wordsSubject)
            .disposed(by: disposeBag)
    }
    
    // 2. Pull-to-Refresh
    private func bindRefresh(input: Input) {
        input.refreshTrigger
            .flatMapLatest { [weak self] _ -> Observable<[WordEntity]> in
                guard let self = self else { return .empty() }
                return self.useCase.recommendRandomWords(level: self.currentLevel).asObservable()
            }
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: wordsSubject)
            .disposed(by: disposeBag)
    }
    
    // 3. 검색
    private func bindSearch(input: Input) {
        input.searchText
            .distinctUntilChanged()
            .flatMapLatest { [weak self] keyword -> Observable<[WordEntity]> in
                guard let self = self else { return .empty() }
                if keyword.isEmpty {
                    return self.useCase.fetchAllWordsMerged(level: self.currentLevel).asObservable()
                } else {
                    return self.useCase.searchWordsMerged(keyword: keyword, level: self.currentLevel).asObservable()
                }
            }
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: wordsSubject)
            .disposed(by: disposeBag)
    }
    
    // 4. +버튼: 단어 저장 + 중복 체크
    private func bindAddWord(input: Input) {
        input.addWordTap
            .flatMapLatest { [weak self] word -> Observable<AddWordResult> in
                guard let self = self else { return .empty() }
                print("➕ [단어 추가 시도] \(word.word)")

                return self.useCase.checkDuplicate(word: word.word)
                    .asObservable()
                    .flatMap { (exists, level) -> Observable<AddWordResult> in
                        if exists {
                            print("⚠️ [중복 확인] \(word.word)는 이미 존재")
                            if let level = level {
                                return .just(.duplicateInLevel(word: word.word, level: level))
                            } else {
                                return .just(.duplicate)
                            }
                        } else {
                            return self.useCase.saveWord(word: word)
                                .map { $0 ? .success : .fail }
                                .asObservable()
                        }
                    }
            }
            .bind(to: addResultSubject)
            .disposed(by: disposeBag)
        
    }
    
    // 5. 모달에서 직접 단어 입력: 중복 체크 + 저장
    private func bindAddCustomWord(input: Input) {
        input.addCustomWordTap
            .flatMapLatest { [weak self] (en, ko, example) -> Observable<AddWordResult> in
                guard let self = self else { return .empty() }
                print("📝 [커스텀 단어 추가 시도] \(en): \(ko)")
                
                // 저장 시 앞,뒤 공백 제거
                let trimmedEn = en.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedKo = ko.trimmingCharacters(in: .whitespacesAndNewlines)

                let word = WordEntity(
                    id: UUID(),
                    word: trimmedEn,
                    meaning: trimmedKo,
                    example: example ?? "",
                    level: self.currentLevel,
                    isCorrect: nil
                )
                
                return self.useCase.saveWord(word: word)
                    .map { $0 ? .success : .fail }
                    .asObservable()
            }
            .bind(to: addResultSubject)
            .disposed(by: disposeBag)
    }
    
    // 6. 결과에 따라 Alert 출력
    private func bindAlert() {
        addResultSubject
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.showAlertSubject.onNext("단어가 저장되었습니다.")
                case .fail:
                    self.showAlertSubject.onNext("저장에 실패했습니다. 다시 시도해 주세요.")
                case .duplicate:
                    self.showAlertSubject.onNext("이미 등록된 단어입니다.")
                case .duplicateInLevel(_, _):
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
