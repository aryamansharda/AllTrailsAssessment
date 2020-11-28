//
//  LunchListViewController.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import Foundation
import UIKit

protocol LunchListVCInteractor {
    func generatePhotoURL(place: Place) -> String?
}

final class LunchListVCDefaultInteractor: LunchListVCInteractor {
    func generatePhotoURL(place: Place) -> String? {
        guard let photoReference = place.photos?.first?.photoReference else {
            return nil
        }

        return GooglePlacesAPI.generatePhotoURL(from: photoReference)
    }
}

protocol LunchListVCDelegate: AnyObject {
    func lunchListVCDidSelectPlace(_ lunchListVC: LunchListViewController, place: Place)
}

final class LunchListViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet fileprivate(set) var tableView: UITableView!

    fileprivate var interactor: LunchListVCInteractor = LunchListVCDefaultInteractor()
    fileprivate var dataSource = [Place]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    weak var delegate: LunchListVCDelegate?

    // MARK: - Public
    func injectDependencies(interactor: LunchListVCInteractor) {
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

// MARK: - Table View
extension LunchListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LunchListCell", for: indexPath) as? LunchListCell else {
            return UITableViewCell()
        }

        let photoURL = interactor.generatePhotoURL(place: dataSource[indexPath.row])
        cell.configure(place: dataSource[indexPath.row], photoURL: photoURL)
        return cell
    }
}

extension LunchListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.lunchListVCDidSelectPlace(self, place: dataSource[indexPath.row])
    }
}
