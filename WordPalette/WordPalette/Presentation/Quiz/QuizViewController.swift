//
//  QuizViewController.swift
//  WordPalette
//
//  Created by 박주성 on 5/22/25.
//

import UIKit

final class QuizViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let quizView = QuizView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = quizView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

}

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
