//
//  QuizCardStackView.swift
//  WordPalette
//
//  Created by 박주성 on 5/23/25.
//

import UIKit
import SnapKit

final class QuizCardStackView: UIView {
    
    // MARK: - Properties
    
    private var cardViews: [QuizCardView] = []
    
    // MARK: - Gesture
        
    private func addPanGestureToTopCard() {
        guard let topCard = cardViews.last else { return }
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        topCard.addGestureRecognizer(pan)
    }
    
    @objc
    private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let card = gesture.view else { return }
        let translation = gesture.translation(in: self)

        let percent = translation.x / self.bounds.width
        let rotation = percent * 0.2
        card.transform = CGAffineTransform(translationX: translation.x, y: 0)
            .rotated(by: rotation)

        if gesture.state == .ended {
            let shouldDismiss = abs(translation.x) > 100
            if shouldDismiss {
                let direction: CGFloat = translation.x < 0 ? -1 : 1
                UIView.animate(withDuration: 0.3, animations: {
                    card.transform = CGAffineTransform(translationX: direction * 1000, y: 0)
                    card.alpha = 0
                }, completion: { _ in
                    card.removeFromSuperview()
                    self.cardViews.removeLast()
                    self.addPanGestureToTopCard()
                })
            } else {
                UIView.animate(withDuration: 0.3) {
                    card.transform = .identity
                }
            }
        }
    }
    
    // MARK: - SetCards
    
    func setCards(_ cards: [QuizCardView]) {
        cardViews = cards.reversed()
        subviews.forEach { $0.removeFromSuperview() }
        
        for card in cardViews {
            addSubview(card)
            
            card.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.size.equalToSuperview()
            }
        }
        
        addPanGestureToTopCard()
    }
}
