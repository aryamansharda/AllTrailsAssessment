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
    @IBOutlet fileprivate(set) var placeNameLabel: UILabel!
    @IBOutlet fileprivate(set) var supportingTextLabel: UILabel!
    @IBOutlet fileprivate(set) var starStackView: UIStackView!
    @IBOutlet fileprivate(set) var ratingCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Asset.Colors.white.color
        layer.borderWidth = 1
        layer.borderColor = Asset.Colors.lightGray.color.cgColor
        layer.cornerRadius = 8
        layer.maskedCorners = [.layerMaxXMaxYCorner,
                                             .layerMaxXMinYCorner,
                                             .layerMinXMaxYCorner,
                                             .layerMinXMinYCorner]

        placeNameLabel.font = TextStyle.bold.font
        placeNameLabel.textColor = Asset.Colors.boldText.color

        supportingTextLabel.font = TextStyle.subtitle.font
        supportingTextLabel.textColor = Asset.Colors.subtitleText.color

        ratingCountLabel.font = TextStyle.subtitle.font
        ratingCountLabel.textColor = Asset.Colors.subtitleText.color

    }

    func configure(place: Place, photoURL: String?) {
        if let photoURL = photoURL {
            thumbnailImageView.loadImageFromURL(urlString: photoURL)
        }

        placeNameLabel.text = place.name

        layer.cornerRadius = 12
        layer.borderWidth = 2
        layer.borderColor = UIColor.green.cgColor

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

        if supportingText.isEmpty {

        }

        supportingTextLabel.text = supportingText
    }

    fileprivate func setupRatingView(_ place: Place) {
        for index in 0..<Int(place.rating.rounded()) {
            starStackView.arrangedSubviews[index].tintColor = Asset.Colors.starYellow.color
        }
        ratingCountLabel.text = "(\(place.userRatingsTotal))"
    }
}
