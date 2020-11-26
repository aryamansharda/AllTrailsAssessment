//
//  ViewController.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import UIKit

/// For testing purposes, this allows us to easily substitute in a mock API that returns a hard-coded set of places
protocol MainVCInteractor {
    func fetchPlaces(completion: @escaping (Result<NearbyPlacesResponse, Error>) -> Void)
}

final class MainVCDefaultInteractor: MainVCInteractor {
    func fetchPlaces(completion: @escaping (Result<NearbyPlacesResponse, Error>) -> Void) {
        let endpoint = GooglePlacesAPI.getNearbyPlaces(searchText: "burgers")
        NetworkManager.request(endpoint: endpoint) { (result: Result<NearbyPlacesResponse, Error>) in
            completion(result)
        }
    }
}

final class MainVCTestInteractor: MainVCInteractor {
    func fetchPlaces(completion: @escaping (Result<NearbyPlacesResponse, Error>) -> Void) {
//        completion(.success("Test Places"))
    }
}

final class MainViewController: UIViewController {
    fileprivate var interactor: MainVCInteractor = MainVCDefaultInteractor()
    fileprivate var lunchMapVC: LunchMapViewController {
        return StoryboardScene.Main.lunchMapViewController.instantiate()
    }

    fileprivate var candidateListVC: CandidateListViewController {
        return StoryboardScene.Main.candidateListViewController.instantiate()
    }

    fileprivate enum DisplayState {
        case map
        case list
    }

    fileprivate var state: DisplayState = .map {
        didSet {
            updateToggleButton()
        }
    }

    // MARK: - Public
    @IBOutlet fileprivate(set) var containerView: UIView!
    @IBOutlet fileprivate(set) var searchContainerView: UIView!
    @IBOutlet fileprivate(set) var filtersContainerView: UIView!
    @IBOutlet fileprivate(set) var toggleDisplayButton: UIButton!
    @IBOutlet fileprivate(set) var toggleFilterButton: UIButton!
    @IBOutlet fileprivate(set) var filterSectionHeightConstraint: NSLayoutConstraint!

    func injectDependencies(interactor: MainVCInteractor) {
        self.interactor = interactor
    }

    // MARK: - UIViewController
    fileprivate func setupListView() {
        candidateListVC.injectDependencies(interactor: CandidateListVCDefaultInteractor())
        add(candidateListVC, to: containerView)
    }

    fileprivate func setupMapView() {
//        add(lunchMapVC, to: containerView)
    }

    fileprivate func setupFilterSection() {
        toggleFilterButton.layer.cornerRadius = 6
        toggleFilterButton.layer.borderWidth = 1
        toggleFilterButton.layer.borderColor = Asset.Colors.lightGray.color.cgColor
        toggleFilterButton.setTitle("Filter", for: .normal)
        toggleFilterButton.titleLabel?.font = TextStyle.subtitle.font
        toggleFilterButton.setTitleColor(Asset.Colors.boldText.color, for: .normal)

        filtersContainerView.isHidden = true
        filtersContainerView.alpha = 0
        filterSectionHeightConstraint.constant = 0
        view.layoutIfNeeded()
    }

    fileprivate func setupSearchContainerView() {
        searchContainerView.layer.shadowColor = Asset.Colors.shadow.color.cgColor
        searchContainerView.layer.shadowOpacity = 0.05
        searchContainerView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        searchContainerView.layer.shadowRadius = 4.0
    }

    fileprivate func setupToggleButton() {
        toggleDisplayButton.setTitleColor(Asset.Colors.white.color, for: .normal)
        toggleDisplayButton.backgroundColor = Asset.Colors.buttonGreen.color
        toggleDisplayButton.layer.masksToBounds = false
        toggleDisplayButton.layer.shadowColor = Asset.Colors.shadow.color.cgColor
        toggleDisplayButton.layer.shadowOpacity = 0.2
        toggleDisplayButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        toggleDisplayButton.layer.shadowRadius = 4.0
        toggleDisplayButton.layer.cornerRadius = 6.0
        toggleDisplayButton.titleLabel?.font = TextStyle.bold.font
        toggleDisplayButton.setTitleColor(Asset.Colors.white.color, for: .normal)

        updateToggleButton()
    }

    fileprivate func updateToggleButton() {
        UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            switch self.state {
            case .map:
                self.toggleDisplayButton.setTitle(L10n.listViewButton, for: .normal)
                self.toggleDisplayButton.setImage(Asset.Assets.listButtonIcon.image, for: .normal)

                self.candidateListVC.remove()
                self.add(self.lunchMapVC, to: self.containerView)
            case .list:
                self.toggleDisplayButton.setTitle(L10n.mapViewButton, for: .normal)
                self.toggleDisplayButton.setImage(Asset.Assets.mapButtonIcon.image, for: .normal)

                self.lunchMapVC.remove()
                self.add(self.candidateListVC, to: self.containerView)
            }
        }, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRequiredData()

        setupMapView()
        setupListView()
        setupToggleButton()
        setupFilterSection()
        setupSearchContainerView()
    }

    fileprivate func fetchRequiredData() {
        interactor.fetchPlaces { result in
            switch result {
            case .success(let places):
                print(places)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    // TODO: Add mark for events
    @IBAction func toggleButtonPressed(_ sender: UIButton) {
        state = state == .list ? .map : .list
    }

    @IBAction func toggleFilterPressed(_ sender: UIButton) {
        if filtersContainerView.isHidden {
            self.filtersContainerView.isHidden = false

            UIView.animate(withDuration: 0.3) {
                self.filtersContainerView.alpha = 1
                self.filterSectionHeightConstraint.constant = 60
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.filtersContainerView.alpha = 0
                self.filterSectionHeightConstraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.filtersContainerView.isHidden = true
            })

        }
    }
}
