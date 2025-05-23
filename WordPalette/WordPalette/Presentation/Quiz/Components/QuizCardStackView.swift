//
//  QuizCardStackView.swift
//  WordPalette
//
//  Created by 박주성 on 5/23/25.
//

import UIKit
import SnapKit
import RxRelay

final class QuizCardStackView: UIView {
    
    // MARK: - Properties
    
    let swipeResult = PublishRelay<Bool>()
    
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
        
        switch gesture.state {
        case .changed:
            applyTransform(to: card, with: translation)
        case .ended:
            handlePanEnded(on: card, with: translation)
        default:
            break
        }
    }
    
    /// 사용자가 스와이프 중일 때 카드 회전 + 이동 적용
    private func applyTransform(to card: UIView, with translation: CGPoint) {
        let percent = translation.x / self.bounds.width
        let rotation = percent * 0.2
        card.transform = CGAffineTransform(translationX: translation.x, y: 0)
            .rotated(by: rotation)
    }
    
    /// 스와이프가 끝났을 때: 조건에 따라 카드 삭제 or 복원
    private func handlePanEnded(on card: UIView, with translation: CGPoint) {
        let shouldDismiss = abs(translation.x) > 100
        let isLeftSwipe = translation.x < 0
        
        if shouldDismiss {
            dismissCard(card, toLeft: isLeftSwipe)
        } else {
            restoreCard(card)
        }
    }
    
    /// 카드 삭제 애니메이션 실행 + 다음 카드에 제스처 추가 + 결과 전파
    private func dismissCard(_ card: UIView, toLeft: Bool) {
        let direction: CGFloat = toLeft ? -1 : 1
        UIView.animate(withDuration: 0.3, animations: {
            card.transform = CGAffineTransform(translationX: direction * 1000, y: 0)
            card.alpha = 0
        }, completion: { _ in
            card.removeFromSuperview()
            self.cardViews.removeLast()
            self.addPanGestureToTopCard()
            self.swipeResult.accept(toLeft)
        })
    }
    
    /// 카드 복원 애니메이션 실행 (원래 위치로 되돌리기)
    private func restoreCard(_ card: UIView) {
        UIView.animate(withDuration: 0.3) {
            card.transform = .identity
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
