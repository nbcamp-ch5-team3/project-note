//
//  PaddingLabel.swift
//  WordPalette
//
//  Created by Quarang on 5/21/25.
//
import UIKit

// MARK: - PaddedLabel
final class PaddedLabel: UILabel {
    
    var padding: UIEdgeInsets

    init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        padding = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 텍스트를 그릴 영역 조정
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    // intrinsicContentSize도 패딩 포함
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}
