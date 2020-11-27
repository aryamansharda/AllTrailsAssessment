//
//  LunchListCell.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/25/20.
//

import Foundation
import UIKit

protocol LunchListCellDelegate: AnyObject {
    func lunchListCellDidPressFavorite(_ lunchListCell: LunchListCell, location: String)
}

class LunchListCell: UITableViewCell {
    @IBOutlet fileprivate(set) var containerView: UIView!
    @IBOutlet fileprivate(set) var thumbnailImageView: UIImageView!
    @IBOutlet fileprivate(set) var placeNameLabel: UILabel!
    @IBOutlet fileprivate(set) var supportingTextLabel: UILabel!
    @IBOutlet fileprivate(set) var favoriteButton: UIButton!
    @IBOutlet fileprivate(set) var starStackView: UIStackView!
    @IBOutlet fileprivate(set) var ratingCountLabel: UILabel!

    weak var delegate: LunchListCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = Asset.Colors.white.color
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = Asset.Colors.lightGray.color.cgColor
        containerView.layer.cornerRadius = 8
        containerView.layer.maskedCorners = [.layerMaxXMaxYCorner,
                                             .layerMaxXMinYCorner,
                                             .layerMinXMaxYCorner,
                                             .layerMinXMinYCorner]

        placeNameLabel.font = TextStyle.bold.font
        placeNameLabel.textColor = Asset.Colors.boldText.color

        supportingTextLabel.font = TextStyle.subtitle.font
        supportingTextLabel.textColor = Asset.Colors.subtitleText.color

        ratingCountLabel.font = TextStyle.subtitle.font
        ratingCountLabel.textColor = Asset.Colors.subtitleText.color

        contentView.backgroundColor = Asset.Colors.background.color
    }

    @IBAction fileprivate func didPressFavorite(_ sender: UIButton) {
        favoriteButton.isSelected = !favoriteButton.isSelected

        //swiftlint:disable:next line_length
        let image = favoriteButton.isSelected ? Asset.Assets.favoriteUnselected.image : Asset.Assets.favoriteSelected.image
        favoriteButton.setImage(image, for: .normal)
    }

    func configure(place: Place, photoURL: String?) {
        if let photoURL = photoURL {
            thumbnailImageView.loadImageFromURL(urlString: photoURL)
        }

        placeNameLabel.text = place.name

        setupSupportingText(place)
        setupRatingView(place)
    }

    fileprivate func setupSupportingText(_ place: Place) {
        var supportingText = String()

        if let priceLevel = place.priceLevel {
            supportingText += String(repeating: "$", count: priceLevel)
        }

        if let isOpenNow = place.openingHours?.openNow {
            if place.priceLevel != nil {
                supportingText += L10n.bulletPoint
            }

            let currentStatus = (isOpenNow ? L10n.candidateRestaurantOpen : L10n.candidateRestaurantClosed)
            supportingText += currentStatus
        }

        supportingTextLabel.text = supportingText
    }

    fileprivate func setupRatingView(_ place: Place) {
        if let rating = place.rating {
            for index in 0..<Int(rating.rounded()) {
                starStackView.arrangedSubviews[index].tintColor = Asset.Colors.starYellow.color
            }
        }

        if let userRatingsTotal = place.userRatingsTotal {
            ratingCountLabel.text = "(\(userRatingsTotal))"
        }
    }
}
