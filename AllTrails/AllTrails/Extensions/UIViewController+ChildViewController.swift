//
//  UIViewController+ChildViewController.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/25/20.
//

import Foundation
import UIKit

extension UIViewController {
    func addChild(_ child: UIViewController, to view: UIView) {
        addChild(child)
        view.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        child.view.pinEdges(to: view)
        child.didMove(toParent: self)
    }

    func removeChild() {
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
