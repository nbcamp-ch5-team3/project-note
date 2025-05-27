//
//  Extension+Toast.swift
//  WordPalette
//
//  Created by iOS study on 5/27/25.
//

import UIKit

extension UIViewController {
    func showToast(message: String, duration: Double = 2.0) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        toastLabel.textColor = .black
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true

        let maxWidth = view.frame.size.width * 0.8
        let maxSize = CGSize(width: maxWidth, height: view.frame.size.height)
        var expectedSize = toastLabel.sizeThatFits(maxSize)
        expectedSize.width += 32
        expectedSize.height += 16

        toastLabel.frame = CGRect(
            x: (view.frame.size.width - expectedSize.width) / 2,
            y: view.frame.size.height - expectedSize.height - 180,
            width: expectedSize.width,
            height: expectedSize.height
        )

        view.addSubview(toastLabel)
        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
