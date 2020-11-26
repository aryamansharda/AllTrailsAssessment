//
//  ViewController.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import UIKit

/// For testing purposes, this allows us to easily substitute in a mock API that returns a hard-coded set of places
protocol MainVCInteractor {
    var dataSource: [Place] { get set }

    func openPlaceInMaps(place: Place)
    func fetchPlaces(query: String?, completion: @escaping (Result<[Place], Error>) -> Void)
    func filterResults(isOpen: Bool?, pricingTier: Int?) -> [Place]
}

final class MainVCDefaultInteractor: MainVCInteractor {
    var dataSource = [Place]()

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
        let endpoint = GooglePlacesAPI.getNearbyPlaces(searchText: query)
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
    fileprivate var candidateListVC: CandidateListViewController = StoryboardScene.Main.candidateListViewController.instantiate()

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
    @IBOutlet fileprivate(set) var toggleDisplayButton: UIButton!
    @IBOutlet fileprivate(set) var toggleFilterButton: UIButton!
    @IBOutlet fileprivate(set) var openNowButton: UIButton!
    @IBOutlet fileprivate(set) var filterSectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate(set) var searchBar: ATSearchBar!
    @IBOutlet fileprivate(set) var priceSegmentedControl: UISegmentedControl!

    func injectDependencies(interactor: MainVCInteractor) {
        self.interactor = interactor
    }

    // MARK: - UIViewController
    fileprivate func setupListView() {
        candidateListVC.injectDependencies(interactor: CandidateListVCDefaultInteractor())
        candidateListVC.delegate = self
        add(candidateListVC, to: containerView)
    }

    fileprivate func setupMapView() {

    }

    fileprivate func setupFilterSection() {
        toggleFilterButton.layer.cornerRadius = 6
        toggleFilterButton.layer.borderWidth = 1
        toggleFilterButton.layer.borderColor = Asset.Colors.lightGray.color.cgColor
        toggleFilterButton.setTitle("Filter", for: .normal)
        toggleFilterButton.titleLabel?.font = TextStyle.subtitle.font
        toggleFilterButton.setTitleColor(Asset.Colors.boldText.color, for: .normal)

        filtersContainerView.backgroundColor = .systemGroupedBackground
        filtersContainerView.layer.cornerRadius = 6
        filtersContainerView.clipsToBounds = true
        filtersContainerView.isHidden = true
        filtersContainerView.alpha = 0
        filterSectionHeightConstraint.constant = 0

        openNowButton.layer.cornerRadius = 6
        openNowButton.layer.borderWidth = 1
        openNowButton.layer.borderColor = Asset.Colors.lightGray.color.cgColor
        openNowButton.setTitle(L10n.filterOpenNow, for: .normal)
        openNowButton.titleLabel?.font = TextStyle.subtitle.font
        openNowButton.setTitleColor(Asset.Colors.boldText.color, for: .normal)
        openNowButton.setTitleColor(Asset.Colors.white.color, for: .selected)

        let font: [NSAttributedString.Key: Any] = [.font: TextStyle.subtitle.font]
        priceSegmentedControl.setTitleTextAttributes(font, for: .normal)
        view.layoutIfNeeded()
    }

    fileprivate func setupSearchContainerView() {
        searchContainerView.layer.shadowColor = Asset.Colors.shadow.color.cgColor
        searchContainerView.layer.shadowOpacity = 0.05
        searchContainerView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        searchContainerView.layer.shadowRadius = 4.0
        searchBar.delegate = self
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

    fileprivate func searchForPlaces(with query: String? = nil) {
        interactor.fetchPlaces(query: query) { [weak self] result in
            switch result {
            case .success(let places):
                self?.candidateListVC.updatePlaces(places: places)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    fileprivate func fetchRequiredData() {
        searchForPlaces()
    }

    fileprivate func filterPlaces() {
        let pricingTier = priceSegmentedControl.selectedSegmentIndex == priceSegmentedControl.numberOfSegments - 1 ? nil : priceSegmentedControl.selectedSegmentIndex + 1
        let isOpen = openNowButton.isSelected ? true : nil
        let filteredResults = interactor.filterResults(isOpen: isOpen, pricingTier: pricingTier)
        candidateListVC.updatePlaces(places: filteredResults)
    }

    // TODO: Add mark for events
    @IBAction fileprivate func toggleButtonPressed(_ sender: UIButton) {
        state = state == .list ? .map : .list
    }

    @IBAction fileprivate func filterOpenNowPressed(_ sender: UIButton) {
        openNowButton.isSelected = !openNowButton.isSelected
        openNowButton.backgroundColor = openNowButton.isSelected ? Asset.Colors.buttonGreen.color : Asset.Colors.lightGray.color
        filterPlaces()
    }

    @IBAction fileprivate func priceTierValueChanged(_ sender: UISegmentedControl) {
        filterPlaces()
    }

    @IBAction fileprivate func toggleFilterPressed(_ sender: UIButton) {
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

extension MainViewController: CandidateListVCDelegate {
    func candidateListVCDidSelectPlace(_ candidateListVC: CandidateListViewController, place: Place) {
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
