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
        
        return Output(
            words: wordsSubject.asObservable(),
            addResult: addResultSubject.asObservable(),
            showAlert: showAlertSubject.asObservable()
        )
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
                    return self.useCase.recommendRandomWords(level: self.currentLevel).asObservable()
                } else {
                    return self.useCase.searchWords(keyword: keyword, level: self.currentLevel).asObservable()
                }
            }
            .bind(to: wordsSubject)
            .disposed(by: disposeBag)
    }
    
    // 4. +버튼: 단어 저장 + 중복 체크
    private func bindAddWord(input: Input) {
        input.addWordTap
            .flatMapLatest { [weak self] word -> Observable<AddWordResult> in
                guard let self = self else { return .empty() }
                return self.useCase.checkDuplicate(word: word.word)
                    .asObservable()
                    .flatMap { (exists, level) -> Observable<AddWordResult> in
                        if exists {
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
                let word = WordEntity(
                    id: UUID(),
                    word: en,
                    meaning: ko,
                    example: example ?? "",
                    level: self.currentLevel,
                    isCorrect: nil
                )
                return self.useCase.checkDuplicate(word: en)
                    .asObservable()
                    .flatMap { (exists, level) -> Observable<AddWordResult> in
                            if exists {
                                if let level = level {
                                    return .just(.duplicateInLevel(word: en, level: level))
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
                case .duplicateInLevel(let word, let level):
                    self.showAlertSubject.onNext("\(word)는 \(level.rawValue)에 이미 있는 단어입니다.")
                }
            })
            .disposed(by: disposeBag)
    }
}
