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
        returnKeyType = .search
        heightAnchor.constraint(equalToConstant: 32).isActive = true

        searchTextField.leftView = nil
        searchTextField.clearButtonMode = .never
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 6
        searchTextField.layer.borderColor = Asset.Colors.lightGray.color.cgColor
//
//        setShadowWithColor(opacity: 1.0, offset: CGSize(width: 0, height: 1), radius: 2)
//
//        let searchIcon = UIImageView()
//        searchIcon.image = Asset.Assets.mapButtonIcon.image
//        searchTextField.addSubview(searchIcon)
//        searchIcon.translatesAutoresizingMaskIntoConstraints = false
//        searchIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        searchIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        searchIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
//        searchIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        let attributes: [NSAttributedString.Key: Any] = [.font: TextStyle.bold.font]
        searchTextField.attributedPlaceholder = NSAttributedString(string: L10n.searchForARestaurant,
                                                                   attributes: attributes)
        searchTextField.font = TextStyle.bold.font
    }
}
