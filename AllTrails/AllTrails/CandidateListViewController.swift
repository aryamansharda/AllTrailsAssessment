//
//  CandidateListViewController.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import Foundation
import UIKit

protocol CandidateListVCInteractor {
    var dataSource: [Place] { get set }
    func generatePhotoURL(place: Place) -> String?
}

final class CandidateListVCDefaultInteractor: CandidateListVCInteractor {
    var dataSource = [Place]()

    func generatePhotoURL(place: Place) -> String? {
        guard let photoReference = place.photos.first?.photoReference else {
            return nil
        }

        return GooglePlacesAPI.generatePhotoURL(from: photoReference)
    }
}

final class CandidateListViewController: UIViewController {
    @IBOutlet fileprivate(set) var tableView: UITableView!

    fileprivate var interactor: CandidateListVCInteractor = CandidateListVCDefaultInteractor()
    private var dataSource = [Place]()

    // MARK: - Public
    func injectDependencies(interactor: CandidateListVCInteractor) {
        self.interactor = interactor
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.backgroundColor = Asset.Colors.background.color
        view.backgroundColor = Asset.Colors.background.color

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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CandidateCell",
                                                       for: indexPath) as? CandidateCell else {
            return UITableViewCell()
        }

        let photoURL = interactor.generatePhotoURL(place: dataSource[indexPath.row])
        cell.configure(place: dataSource[indexPath.row], photoURL: photoURL)

        return cell
    }
}
