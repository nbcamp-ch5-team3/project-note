//
//  SceneDelegate.swift
//  WordPalette
//
//  Created by 박주성 on 5/20/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = AddWordViewController(selectedLevel: .advanced)
        window?.makeKeyAndVisible()
    }
}
