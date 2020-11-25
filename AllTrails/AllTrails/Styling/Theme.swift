//
//  Theme.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import Foundation
import UIKit

final class Theme {
    final class Color {
        class var navigationBarButtonTextColor: UIColor {
            return .black
        }
    }

    final class Font {
        static let standardBrandFont = "HelveticaNeue"
        class func regular(size: CGFloat) -> UIFont {
            return UIFont(name: standardBrandFont, size: size)!
        }

        class func bold(size: CGFloat) -> UIFont {
            return UIFont(name: "\(standardBrandFont)-Bold", size: size)!
        }
    }

    final class func setAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: Theme.Color.navigationBarButtonTextColor,
                                                            .font: Theme.Font.bold(size: 18)]
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().isTranslucent = false

        let barButtonItemTitleTextAttributes: [NSAttributedString.Key: Any] = [
            .font: Theme.Font.regular(size: 18),
            .foregroundColor: Theme.Color.navigationBarButtonTextColor
        ]

        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonItemTitleTextAttributes, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonItemTitleTextAttributes, for: .highlighted)
    }
}
