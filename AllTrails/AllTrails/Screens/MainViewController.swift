//
//  ViewController.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import UIKit
import CoreLocation

protocol MainVCInteractor {
    var dataSource: [Place] { get set }
    var lastKnownLocation: CLLocationCoordinate2D? { get set }

    func openPlaceInMaps(place: Place)
    func fetchPlaces(query: String?, completion: @escaping (Result<[Place], Error>) -> Void)
    func filterResults(isOpen: Bool?, pricingTier: Int?) -> [Place]
}

final class MainVCDefaultInteractor: MainVCInteractor {
    var dataSource = [Place]()
    var lastKnownLocation: CLLocationCoordinate2D?

    func openPlaceInMaps(place: Place) {
        if let encodedAddress = place.vicinity.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
           let url = URL(string: "http://maps.apple.com/?address=\(encodedAddress)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    func filterResults(isOpen: Bool?, pricingTier: Int?) -> [Place] {
        var filteredResults = dataSource

        if let pricingTier = pricingTier {
            filteredResults = filteredResults.filter { $0.priceLevel == pricingTier }
        }

        if let isOpen = isOpen {
            filteredResults = filteredResults.filter { $0.openingHours?.openNow == isOpen }
        }

        return filteredResults
    }

    func fetchPlaces(query: String?, completion: @escaping (Result<[Place], Error>) -> Void) {
        guard let latitude = lastKnownLocation?.latitude, let longitude = lastKnownLocation?.longitude else {
            print("No location fix available.")
            return
        }

        let endpoint = GooglePlacesAPI.getNearbyPlaces(searchText: query, latitude: latitude, longitude: longitude)
        NetworkManager.request(endpoint: endpoint) { (result: Result<NearbyPlacesResponse, Error>) in
            switch result {
            case .success(let response):
                self.dataSource = response.results.filter { $0.priceLevel != nil && $0.openingHours != nil }
                completion(.success(self.dataSource))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}

final class MainViewController: UIViewController {
    fileprivate var interactor: MainVCInteractor = MainVCDefaultInteractor()
    fileprivate var lunchMapVC: LunchMapViewController = StoryboardScene.Main.lunchMapViewController.instantiate()
    fileprivate var lunchListVC: LunchListViewController = StoryboardScene.Main.lunchListViewController.instantiate()
    fileprivate var locationService = LocationService()

    fileprivate enum DisplayState {
        case map
        case list
    }

    fileprivate var state: DisplayState = .list {
        didSet {
            updateToggleButton()
        }
    }

    // MARK: - Public
    @IBOutlet fileprivate(set) var containerView: UIView!
    @IBOutlet fileprivate(set) var searchContainerView: UIView!
    @IBOutlet fileprivate(set) var filtersContainerView: UIView!
    @IBOutlet fileprivate(set) var toggleDisplayButton: ATFloatingButton!
    @IBOutlet fileprivate(set) var toggleFilterButton: ATToggleButton!
    @IBOutlet fileprivate(set) var openNowButton: ATToggleButton!
    @IBOutlet fileprivate(set) var searchBar: ATSearchBar!
    @IBOutlet fileprivate(set) var filterSectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate(set) var priceSegmentedControl: UISegmentedControl!

    func injectDependencies(interactor: MainVCInteractor) {
        self.interactor = interactor
    }

    // MARK: - UIViewController
    fileprivate func setupListView() {
        lunchListVC.injectDependencies(interactor: LunchListVCDefaultInteractor())
        lunchListVC.delegate = self
        addChild(lunchListVC, to: containerView)
    }

    fileprivate func setupMapView() {
        lunchMapVC.injectDependencies(interactor: LunchMapVCDefaultInteractor())
        addChild(lunchMapVC, to: containerView)
    }

    fileprivate func setupFilterSection() {
        toggleFilterButton.setTitle(L10n.filter, for: .normal)
        openNowButton.setTitle(L10n.filterOpenNow, for: .normal)

        filtersContainerView.backgroundColor = .systemGroupedBackground
        filtersContainerView.layer.cornerRadius = 6
        filtersContainerView.clipsToBounds = true
        filtersContainerView.isHidden = true
        filtersContainerView.alpha = 0
        filterSectionHeightConstraint.constant = 0

        let font: [NSAttributedString.Key: Any] = [.font: TextStyle.subtitle.font]
        priceSegmentedControl.setTitleTextAttributes(font, for: .normal)
    }

    fileprivate func setupSearchContainerView() {
        searchContainerView.layer.shadowColor = Asset.Colors.shadow.color.cgColor
        searchContainerView.layer.shadowOpacity = 0.05
        searchContainerView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        searchContainerView.layer.shadowRadius = 4.0
        searchBar.delegate = self
    }

    fileprivate func updateToggleButton() {
        UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            switch self.state {
            case .map:
                self.toggleDisplayButton.setTitle(L10n.listViewButton, for: .normal)
                self.toggleDisplayButton.setImage(Asset.Assets.listButtonIcon.image, for: .normal)
                self.lunchListVC.view.isHidden = true
                self.lunchMapVC.view.isHidden = false
            case .list:
                self.toggleDisplayButton.setTitle(L10n.mapViewButton, for: .normal)
                self.toggleDisplayButton.setImage(Asset.Assets.mapButtonIcon.image, for: .normal)
                self.lunchListVC.view.isHidden = false
                self.lunchMapVC.view.isHidden = true
            }
        }, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupListView()
        setupFilterSection()
        setupSearchContainerView()
        updateToggleButton()

        locationService.startLocationUpdates()
        locationService.delegate = self

        searchForPlaces()
    }

    fileprivate func searchForPlaces(with query: String? = nil) {
        interactor.fetchPlaces(query: query) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let places):
                DispatchQueue.main.async {
                    self.lunchMapVC.updatePlaces(places: places)
                    self.lunchListVC.updatePlaces(places: places)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Events
extension MainViewController {
    @IBAction fileprivate func toggleButtonPressed(_ sender: UIButton) {
        state = state == .list ? .map : .list
    }

    @IBAction fileprivate func filterOpenNowPressed(_ sender: UIButton) {
        openNowButton.isSelected = !openNowButton.isSelected
        filterPlaces()
    }

    @IBAction fileprivate func priceTierValueChanged(_ sender: UISegmentedControl) {
        filterPlaces()
    }

    @IBAction fileprivate func toggleFilterPressed(_ sender: UIButton) {
        toggleFilterButton.isSelected = !toggleFilterButton.isSelected

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

    fileprivate func filterPlaces() {
        let pricingTier = priceSegmentedControl.selectedSegmentIndex == priceSegmentedControl.numberOfSegments - 1 ? nil : priceSegmentedControl.selectedSegmentIndex + 1
        let isOpen = openNowButton.isSelected ? true : nil
        let filteredResults = interactor.filterResults(isOpen: isOpen, pricingTier: pricingTier)
        lunchListVC.updatePlaces(places: filteredResults)
        lunchMapVC.updatePlaces(places: filteredResults)
    }
}

extension MainViewController: LunchListVCDelegate {
    func lunchListVCDidSelectPlace(_ candidateListVC: LunchListViewController, place: Place) {
        interactor.openPlaceInMaps(place: place)
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchQuery = searchBar.text else {
            // TODO:
            print("Please enter a phrase")
            return
        }

        searchForPlaces(with: searchQuery)
    }
}

extension MainViewController: LocationServiceDelegate {
    func locationServiceUpdateLocation(currentLocation: CLLocation) {
        interactor.lastKnownLocation = currentLocation.coordinate

        print("Coordinate: ", currentLocation.coordinate)
        if interactor.dataSource.isEmpty {
            searchForPlaces()
        }
    }
}
