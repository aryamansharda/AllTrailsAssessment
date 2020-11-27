//
//  ATSearchBar.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/25/20.
//

import Foundation
import UIKit

final class ATSearchBar: UISearchBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    fileprivate func setup() {
        returnKeyType = .search
        heightAnchor.constraint(equalToConstant: 32).isActive = true

        // Custom styling of search bar / search text field
        clipsToBounds = true
        searchBarStyle = .prominent
        searchTextField.backgroundColor = .white
        layer.borderColor = Asset.Colors.lightGray.color.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 6

        let attributes: [NSAttributedString.Key: Any] = [.font: TextStyle.bold.font]
        searchTextField.font = TextStyle.bold.font
        searchTextField.attributedPlaceholder = NSAttributedString(string: L10n.searchForARestaurant,
                                                                   attributes: attributes)

        // @workaround Re-purposing the bookmark button to show the search bar icon on the right
        showsBookmarkButton = true
        searchTextField.leftView = nil
        searchTextField.clearButtonMode = .whileEditing
        setImage(Asset.Assets.searchBarIcon.image, for: .bookmark, state: .normal)
    }
}
