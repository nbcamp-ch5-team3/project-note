//
//  Extension+UIDevice.swift
//  WordPalette
//
//  Created by Quarang on 5/26/25.
//

import UIKit

extension UIDevice {
    public var isiPhoneSE: Bool {
        if (UIScreen.main.bounds.size.height == 667 || UIScreen.main.bounds.size.width == 375) {
            return true
        }
        return false
    }
}
