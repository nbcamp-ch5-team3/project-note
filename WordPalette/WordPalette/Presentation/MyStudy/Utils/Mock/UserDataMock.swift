//
//  UserDataMock.swift
//  WordPalette
//
//  Created by Quarang on 5/22/25.
//

import Foundation

let userDataMock: UserData = {
    let histories: [StudyHistory] = (1...20).map { _ in
        StudyHistory(
            id: UUID(),
            solvedAt: Calendar.current.date(byAdding: .day, value: -Int.random(in: 0..<100), to: Date()) ?? Date()
        )
    }
    return UserData(score: 42, studyHistorys: histories)
}()

