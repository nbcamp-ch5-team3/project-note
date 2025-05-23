//
//  QuizViewController.swift
//  WordPalette
//
//  Created by 박주성 on 5/22/25.
//

import UIKit

final class QuizViewController: UIViewController {
    
    // MARK: - Properties
    
    private let mockData = [
        WordEntity(
            id: UUID(),
            word: "hello",
            meaning: "안녕",
            example: "hello world",
            level: .beginner,
            isCorrect: nil
        ),WordEntity(
            id: UUID(),
            word: "hello",
            meaning: "안녕",
            example: "hello world",
            level: .beginner,
            isCorrect: nil
        )
        ,WordEntity(
            id: UUID(),
            word: "hello",
            meaning: "안녕",
            example: "hello world",
            level: .beginner,
            isCorrect: nil
        )
    ]

    
    // MARK: - UI Components
    
    private let quizView = QuizView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = quizView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        quizView.update(words: mockData)
    }

}

// MARK: - Configure

private extension QuizViewController {
    func configure() {
        setAttributes()
        setBindings()
    }
    
    func setAttributes() {
        
    }
    
    func setBindings() {
        
    }
}
