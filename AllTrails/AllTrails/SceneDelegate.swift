//
//  SceneDelegate.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        //swiftlint:disable unused_optional_binding
        guard let _ = (scene as? UIWindowScene) else {
            return
        }
    }
}
