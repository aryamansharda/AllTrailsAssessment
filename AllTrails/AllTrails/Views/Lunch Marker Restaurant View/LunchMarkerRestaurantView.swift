//
//  LunchMarkerRestaurantView.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/26/20.
//

import Foundation
import UIKit

final class LunchMarkerRestaurantView: UIView {
    @IBOutlet fileprivate(set) var thumbnailImageView: UIImageView!
    @IBOutlet fileprivate(set) var backgroundImageView: UIImageView!
    @IBOutlet fileprivate(set) var placeNameLabel: UILabel!
    @IBOutlet fileprivate(set) var supportingTextLabel: UILabel!
    @IBOutlet fileprivate(set) var starStackView: UIStackView!
    @IBOutlet fileprivate(set) var ratingCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        placeNameLabel.font = TextStyle.bold.font
        supportingTextLabel.font = TextStyle.subtitle.font
        ratingCountLabel.font = TextStyle.subtitle.font

        placeNameLabel.textColor = Asset.Colors.boldText.color
        supportingTextLabel.textColor = Asset.Colors.subtitleText.color
        ratingCountLabel.textColor = Asset.Colors.subtitleText.color

        backgroundImageView.image = Asset.Assets.mapCard.image
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
