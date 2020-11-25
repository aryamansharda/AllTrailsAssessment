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

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.backgroundColor = Asset.Colors.background.color
    }
}

extension CandidateListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Ensure that force unwrapping is the call hre
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CandidateCell",
                                                       for: indexPath) as? CandidateCell else {
            return UITableViewCell()
        }
        cell.configure(candidate: Candidate.fakeCandidate)
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

    // TODO: Shouldn't be optional
    func configure(candidate: Candidate) {

        placeNameLabel.text = candidate.name
        thumbnailImageView.loadImageFromURL(urlString: candidate.icon)
    }
}

extension Candidate {
    static var fakeCandidate: Candidate {
        Candidate(formattedAddress: "1390 Market Street",
                  geometry: Geometry(location: Location(lat: 30, lng: 30)),
                  icon: "https://images.unsplash.com/photo-1593642532871-8b12e02d091c?ixlib=rb-1.2.1&ixid=MXwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fA%3D%3D&auto=format&fit=crop&w=800&q=60",
                  name: "Restaurant 1",
                  openingHours: nil,
                  photos: [],
                  rating: 3.5)
    }
}
