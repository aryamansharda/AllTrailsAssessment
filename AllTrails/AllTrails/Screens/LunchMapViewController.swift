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

    // MARK: - Properties
    @IBOutlet fileprivate(set) var mapView: GMSMapView!

    fileprivate var interactor: LunchMapVCInteractor = LunchMapVCDefaultInteractor()
    fileprivate var markers = [ATMapMarker]()
    fileprivate var dataSource = [Place]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }

                self.mapView.clear()
                self.dataSource.forEach {
                    let marker = ATMapMarker(place: $0, mapView: self.mapView)
                    self.markers.append(marker)
                }

                self.focusMapToShowAllMarkers()
            }
        }
    }

    weak var delegate: LunchMapVCDelegate?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.background.color

        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
    }

    // MARK: - Public
    func injectDependencies(interactor: LunchMapVCInteractor) {
        self.interactor = interactor
    }

    func updatePlaces(places: [Place]) {
        self.dataSource = places
    }
}

// MARK: - Business Logic
extension LunchMapViewController {
    fileprivate func focusMapToShowAllMarkers() {
        let bounds = markers.reduce(GMSCoordinateBounds()) {
            $0.includingCoordinate($1.position)
        }

        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 120.0))
    }
}

extension LunchMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        guard let mapMarker = marker as? ATMapMarker else {
            Log.warning("Unknown marker type encountered")
            return
        }

        delegate?.lunchMapVCDidSelectPlace(self, place: mapMarker.place)
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        guard let mapMarker = marker as? ATMapMarker else {
            return nil
        }

        let infoWindow: LunchMarkerRestaurantView = LunchMarkerRestaurantView.fromNib()
        infoWindow.configure(place: mapMarker.place, photoURL: interactor.generatePhotoURL(place: mapMarker.place))
        return infoWindow
    }
}
