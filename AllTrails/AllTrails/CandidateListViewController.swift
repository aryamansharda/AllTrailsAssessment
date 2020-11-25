//
//  CandidateListViewController.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import Foundation
import UIKit

final class CandidateListViewController: UIViewController {
    @IBOutlet fileprivate(set) var tableView: UITableView!

    private var dataSource = [Place]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.backgroundColor = Asset.Colors.background.color

        NetworkManager.request(endpoint: GooglePlacesAPI.getNearbyPlaces(searchText: "Burger")) { [weak self] (result: Result<NearbyPlacesResponse, Error>) in
            switch result {
            case .success(let response):
                self?.dataSource = response.results
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure:
                print("Failure")
            }
        }
    }
}

extension CandidateListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Ensure that force unwrapping is the call here
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CandidateCell",
                                                       for: indexPath) as? CandidateCell else {
            return UITableViewCell()
        }
        cell.configure(place: dataSource[indexPath.row])
        return cell
    }
}

protocol CandidateCellDelegate: AnyObject {
    func candidateCellDidPressFavorite(_ candidateCell: CandidateCell, location: String)
}

class CandidateCell: UITableViewCell {
    @IBOutlet fileprivate(set) var containerView: UIView!
    @IBOutlet fileprivate(set) var thumbnailImageView: UIImageView!
    @IBOutlet fileprivate(set) var placeNameLabel: UILabel!
    @IBOutlet fileprivate(set) var supportingTextLabel: UILabel!
    @IBOutlet fileprivate(set) var favoriteButton: UIButton!

    weak var delegate: CandidateCellDelegate?

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

        contentView.backgroundColor = Asset.Colors.background.color
    }

    @IBAction func didPressFavorite(_ sender: UIButton) {
        favoriteButton.isSelected = !favoriteButton.isSelected
        if favoriteButton.isSelected {
            favoriteButton.setImage(Asset.Assets.favoriteUnselected.image, for: .normal)
        } else {
            favoriteButton.setImage(Asset.Assets.favoriteSelected.image, for: .normal)
        }
    }

    func configure(place: Place) {
        placeNameLabel.text = place.name
        thumbnailImageView.loadImageFromURL(urlString: place.icon)
    }
}
