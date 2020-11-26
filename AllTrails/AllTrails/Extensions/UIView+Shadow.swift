//
//  UIView+Shadow.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/25/20.
//

import Foundation
import UIKit

extension UIView {
    func setShadowWithColor(opacity: Float, offset: CGSize, radius: CGFloat) {
        layer.shadowColor = Asset.Colors.shadow.color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius

        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
