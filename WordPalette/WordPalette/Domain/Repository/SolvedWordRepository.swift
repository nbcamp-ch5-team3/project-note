//
//  SolvedWordRepository.swift
//  WordPalette
//
//  Created by 박주성 on 5/21/25.
//

import Foundation
import RxSwift

protocol SolvedWordRepository {
    func saveWord(word: WordEntity) -> Single<Bool>
    func fetchWords(id: UUID) -> Single<[WordEntity]>
    func fetchTodayWords() -> Single<[WordEntity]>
}
