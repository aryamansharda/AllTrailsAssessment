//
//  SceneDelegate.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.makeKeyAndVisible()
            self.window = window

            let applicationCoordinator = AppCoordinator(window: window)
            self.appCoordinator = applicationCoordinator
            applicationCoordinator.start()
        }
    }
}
