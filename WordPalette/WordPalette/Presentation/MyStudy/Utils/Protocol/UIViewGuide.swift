//
//  UIViewCuide.swift
//  WordPalette
//
//  Created by Quarang on 5/21/25.
//

import Foundation

// MARK: UIView 혹은 UICell에 필수로 들어가야할 메서드 정의
protocol UIViewGuide {
    /// 컴포넌트 속성 설정
    func configureAttributes()
    /// 레이아웃 설정
    func configureLayout()
    /// 서브뷰 추가
    func configureSubView()
}
