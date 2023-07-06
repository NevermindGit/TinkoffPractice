//
//  SceneDelegate.swift
//  test
//
//  Created by Vadim Valeev on 01.07.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        if UserCredentials.loadFromCoreData() != nil {
            // User is already logged in, show the main tab bar
            let mainTabBar = MainTabBarController()
            window?.rootViewController = mainTabBar
        } else {
            // No credentials found, show the login screen
            let loginVC = LoginViewController(dataManager: DataManager.shared)
            let navigationController = UINavigationController(rootViewController: loginVC)
            window?.rootViewController = navigationController
        }
        window?.makeKeyAndVisible()
    }


}
