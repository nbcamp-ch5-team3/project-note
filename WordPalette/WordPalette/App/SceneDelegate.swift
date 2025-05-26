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
        window?.rootViewController = HomeViewController()
        window?.makeKeyAndVisible()
    }
    
    /// 탭바 컨트롤러 생성
    private var makeTabBarController: UITabBarController {
        
        // 탭바 구분선 추가
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .lightGray
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        // 탭바 생성 및 VC 추가
        // 각각의 탭바 아이템 추가
        let tabBar = UITabBarController()
        let DIContainer = DIContainer()
        
        let homeVC = DIContainer.makeHomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        
        let quizVC = DIContainer.makeQuizViewController()
        quizVC.tabBarItem = UITabBarItem(title: "퀴즈", image: UIImage(systemName: "questionmark.circle.fill"), tag: 1)
        
        let studyHistoryVC = DIContainer.makeStudyHistoryViewContoller()
        studyHistoryVC.tabBarItem = UITabBarItem(title: "나의 학습", image: UIImage(systemName: "calendar"), tag: 2)
        
        tabBar.overrideUserInterfaceStyle = .light
        tabBar.selectedIndex = 0
        tabBar.tabBar.tintColor = .customMango
        tabBar.viewControllers = [homeVC, quizVC, studyHistoryVC]
        
        return tabBar
    }
}
