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
        return cell
    }
}

protocol CandidateCellDelegate: AnyObject {
    func candidateCellDidPressFavorite(_ candidateCell: CandidateCell, location: String)
}

class CandidateCell: UITableViewCell {
    @IBOutlet fileprivate(set) var thumbnailImageView: UIImageView!
    @IBOutlet fileprivate(set) var placeNameLabel: UILabel!
    @IBOutlet fileprivate(set) var supportingTextLabel: UILabel!

    weak var delegate: CandidateCellDelegate?

    func configure(candidate: Candidate) {
        placeNameLabel.text = candidate.name
        thumbnailImageView.loadImageFromURL(urlString: candidate.icon)
        supportingTextLabel.text = candidate.openingHours
    }
}
