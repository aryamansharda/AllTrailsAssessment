//
//  ATFloatingButton.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/26/20.
//

import Foundation
import UIKit

final class ATFloatingButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    fileprivate func setup() {
        setTitleColor(Asset.Colors.white.color, for: .normal)
        backgroundColor = Asset.Colors.buttonGreen.color
        layer.masksToBounds = false
        layer.shadowColor = Asset.Colors.shadow.color.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 4.0
        layer.cornerRadius = 6.0
        titleLabel?.font = TextStyle.bold.font
        setTitleColor(Asset.Colors.white.color, for: .normal)
    }
}
