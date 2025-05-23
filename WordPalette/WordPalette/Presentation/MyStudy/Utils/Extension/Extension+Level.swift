//
//  Extension+Level.swift
//  WordPalette
//
//  Created by Quarang on 5/22/25.
//

import UIKit

extension Level {
    var color: UIColor {
        switch self {
        case .beginner: .customMango
        case .intermediate: .customOrange
        case .advanced: .customStrawBerry
        }
    }
}
