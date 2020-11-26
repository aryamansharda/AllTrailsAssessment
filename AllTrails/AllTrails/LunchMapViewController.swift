//
//  LunchMapViewController.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/25/20.
//

import Foundation
import UIKit
import GoogleMaps

protocol LunchMapVCInteractor {
    func generatePhotoURL(place: Place) -> String?
}

final class LunchMapVCDefaultInteractor: LunchMapVCInteractor {
    func generatePhotoURL(place: Place) -> String? {
        guard let photoReference = place.photos?.first?.photoReference else {
            return nil
        }

        return GooglePlacesAPI.generatePhotoURL(from: photoReference)
    }
}

protocol LunchMapVCDelegate: AnyObject {
    func lunchMapVCDidSelectPlace(_ lunchMapVC: LunchMapViewController, place: Place)
}

class LunchMapViewController: UIViewController {
    @IBOutlet fileprivate(set) var mapView: GMSMapView!

    fileprivate var interactor: LunchMapVCInteractor = LunchMapVCDefaultInteractor()
    fileprivate var dataSource = [Place]() {
        didSet {
            DispatchQueue.main.async {
                //self.tableView.reloadData()
            }
        }
    }

    weak var delegate: CandidateListVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Asset.Colors.background.color

        let position = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.127)
        let marker = ATMapMarker(position: position)
        marker.configure(title: "London", map: mapView)
    }

    // MARK: - Public
    func injectDependencies(interactor: LunchMapVCInteractor) {
        self.interactor = interactor
    }

    func updatePlaces(places: [Place]) {
        self.dataSource = places
    }
}

final class ATMapMarker: GMSMarker {
    func configure(title: String, map: GMSMapView) {
        icon = Asset.Assets.favoriteUnselected.image
    }
}
