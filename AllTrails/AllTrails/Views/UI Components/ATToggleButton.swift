//
//  ATToggleButton.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/26/20.
//

import Foundation
import UIKit

final class ATToggleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? Asset.Colors.buttonGreen.color : Asset.Colors.lightGray.color
        }
    }

    fileprivate func setup() {
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = Asset.Colors.lightGray.color.cgColor
        titleLabel?.font = TextStyle.subtitle.font
        setTitleColor(Asset.Colors.boldText.color, for: .normal)
        setTitleColor(Asset.Colors.white.color, for: .selected)
    }
}
