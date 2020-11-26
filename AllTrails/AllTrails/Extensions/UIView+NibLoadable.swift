//
//  UIView+NibLoadable.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/26/20.
//

import Foundation
import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        //swiftlint:disable:next force_unwrapping force_cast
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
