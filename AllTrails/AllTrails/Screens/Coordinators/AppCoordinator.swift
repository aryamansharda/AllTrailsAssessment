//
//  SceneDelegate.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    let window: UIWindow
    let mainViewController = StoryboardScene.Main.mainViewController.instantiate()

    init(window: UIWindow) {
        self.window = window
        window.makeKeyAndVisible()
        window.rootViewController = mainViewController
    }

    func start() {
        // We provide all of the required services to the view model by way of dependency injection
        // Typically, we'd have a present/push call here to show the view controller, but as this
        // is the initial view controller, such a call is unnecessary
        mainViewController.injectDependencies(interactor: MainVCDefaultInteractor())
    }
}
