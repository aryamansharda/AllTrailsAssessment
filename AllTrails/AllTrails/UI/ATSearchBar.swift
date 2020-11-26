//
//  ATSearchBar.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/25/20.
//

import Foundation
import UIKit

class ATSearchBar: UISearchBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        placeholder = "Search for a restaurant"
        setImage(Asset.Assets.star.image, for: .search, state: .normal)
        isTranslucent = true

        returnKeyType = .search

//        layer.borderColor = UIColor.emptyGray.cgColor
        searchTextField.leftView = nil
        searchTextField.rightView = UIView() //UIImageView(image: Asset.Assets.mapButtonIcon.image)
        searchTextField.rightView?.backgroundColor = .red
        searchTextField.rightViewMode = .always
        searchTextField.clearButtonMode = .never
        layer.borderWidth = 1
        layer.cornerRadius = 6

    }
}
