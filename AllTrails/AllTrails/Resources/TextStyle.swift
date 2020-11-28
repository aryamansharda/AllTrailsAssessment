//
//  TextStyle.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/25/20.
//

import Foundation
import UIKit

internal enum TextStyle: String {
    case medium
    case subtitle
    case bold

    var font: UIFont {
        switch self {
        case .subtitle:
            return FontFamily.ProximaNova.regular.font(size: 12)
        case .medium:
            return FontFamily.ProximaNova.bold.font(size: 14)
        case .bold:
            return FontFamily.ProximaNova.bold.font(size: 16)
        }
    }
}
