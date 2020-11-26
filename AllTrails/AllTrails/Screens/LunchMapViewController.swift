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
    fileprivate var markers = [ATMapMarker]()
    fileprivate var dataSource = [Place]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }

                self.mapView.clear()
                self.dataSource.forEach {
                    let position = CLLocationCoordinate2D(latitude: $0.geometry.location.lat,
                                                          longitude: $0.geometry.location.lng)
                    let marker = ATMapMarker(position: position)
                    marker.configure(title: $0.name, mapView: self.mapView)
                    self.markers.append(marker)
                }

                self.focusMapToShowAllMarkers()
            }
        }
    }

    //Create a location manager?
    
    weak var delegate: LunchMapVCDelegate?

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

extension LunchMapViewController {
    fileprivate func focusMapToShowAllMarkers() {
        let bounds = markers.reduce(GMSCoordinateBounds()) {
            $0.includingCoordinate($1.position)
        }
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 120.0))
//        mapView.animate(toLocation: bounds.)
//        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: 37.773972, longitude: -122.431297))
//        mapView.animate(toZoom: 15)
    }
}

extension LunchMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.selectedMarker?.icon = Asset.Assets.markerUnselected.image
        mapView.selectedMarker = marker
        marker.icon = Asset.Assets.markerSelected.image
        return true
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {

    }
}

final class ATMapMarker: GMSMarker {
    func configure(title: String, mapView: GMSMapView) {
        icon = Asset.Assets.markerUnselected.image
        map = mapView
        appearAnimation = .pop
    }
}
