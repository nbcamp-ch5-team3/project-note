//
//  CoreDataErrorType.swift
//  WordPalette
//
//  Created by 박주성 on 5/26/25.
//

enum CoreDataErrorType: Error {
    case fetchFailed
    case saveFailed
    case deleteFailed
    case duplicate
}
