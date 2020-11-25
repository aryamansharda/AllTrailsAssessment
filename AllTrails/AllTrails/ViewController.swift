//
//  ViewController.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import UIKit

/// For testing purposes, this allows us to easily substitute in a mock API that returns a hard-coded set of places
protocol MainVCInteractor {
    func fetchPlaces(completion: @escaping (Result<GooglePlacesResponse , Error>) -> ())
}

final class MainVCDefaultInteractor: MainVCInteractor {
    func fetchPlaces(completion: @escaping (Result<GooglePlacesResponse , Error>) -> ()) {
        let endpoint = GooglePlacesAPI.getPlacesResults(searchText: "burgers")
        NetworkManager.request(endpoint: endpoint) { (result: Result<GooglePlacesResponse, Error>) in
            completion(result)
        }
    }
}

final class MainVCTestInteractor: MainVCInteractor {
    func fetchPlaces(completion: @escaping (Result<GooglePlacesResponse , Error>) -> ()) {
//        completion(.success("Test Places"))
    }
}

class MainViewController: UIViewController {

    fileprivate var interactor: MainVCInteractor = MainVCDefaultInteractor()

    // MARK: - Public
    func injectDependencies(interactor: MainVCInteractor) {
        self.interactor = interactor
    }

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRequiredData()
    }

    fileprivate func fetchRequiredData() {
//        guard let interactor = interactor else {
//            return
//        }

        interactor.fetchPlaces { result in
            switch result {
            case .success(let places):
                print(places)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

