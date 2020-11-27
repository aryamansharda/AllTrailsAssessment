//
//  LunchListViewController.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import Foundation
import UIKit

protocol CandidateListVCInteractor {
    func generatePhotoURL(place: Place) -> String?
}

final class CandidateListVCDefaultInteractor: CandidateListVCInteractor {
    func generatePhotoURL(place: Place) -> String? {
        guard let photoReference = place.photos?.first?.photoReference else {
            return nil
        }

        return GooglePlacesAPI.generatePhotoURL(from: photoReference)
    }
}

protocol CandidateListVCDelegate: AnyObject {
    func candidateListVCDidSelectPlace(_ candidateListVC: LunchListViewController, place: Place)
}

final class LunchListViewController: UIViewController {
    @IBOutlet fileprivate(set) var tableView: UITableView!

    fileprivate var interactor: CandidateListVCInteractor = CandidateListVCDefaultInteractor()
    fileprivate var dataSource = [Place]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    weak var delegate: CandidateListVCDelegate?

    // MARK: - Public
    func injectDependencies(interactor: CandidateListVCInteractor) {
        self.interactor = interactor
    }

    func updatePlaces(places: [Place]) {
        self.dataSource = places
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Asset.Colors.background.color
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Asset.Colors.background.color
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
}

extension LunchListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CandidateCell", for: indexPath) as? CandidateCell else {
            return UITableViewCell()
        }

        let photoURL = interactor.generatePhotoURL(place: dataSource[indexPath.row])
        cell.configure(place: dataSource[indexPath.row], photoURL: photoURL)
        return cell
    }
}

extension LunchListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.candidateListVCDidSelectPlace(self, place: dataSource[indexPath.row])
    }
}
