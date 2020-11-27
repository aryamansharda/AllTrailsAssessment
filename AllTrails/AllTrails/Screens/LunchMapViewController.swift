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

    fileprivate let windowInfoSpacing: CGFloat = 80
    fileprivate var infoWindow: LunchMarkerRestaurantView = LunchMarkerRestaurantView.fromNib()
    fileprivate var locationMarker : ATMapMarker?

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

extension LunchMapViewController {
    fileprivate func focusMapToShowAllMarkers() {
        let bounds = markers.reduce(GMSCoordinateBounds()) {
            $0.includingCoordinate($1.position)
        }
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 120.0))
    }
}

extension LunchMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.selectedMarker?.icon = Asset.Assets.markerUnselected.image
        mapView.selectedMarker = marker
        marker.icon = Asset.Assets.markerSelected.image

        guard let mapMarker = marker as? ATMapMarker else {
            return false
        }

        locationMarker = mapMarker
//        infoWindow.removeFromSuperview()
        infoWindow = LunchMarkerRestaurantView.fromNib()
        infoWindow.configure(place: mapMarker.place, photoURL: nil)
        mapMarker.iconView = infoWindow
        mapMarker.icon = Asset.Assets.markerSelected.image
//        infoWindow.center = mapView.projection.point(for: mapMarker.position)
//        infoWindow.center.y -= windowInfoSpacing
//        view.addSubview(infoWindow)

        return true
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        locationMarker?.icon = Asset.Assets.markerUnselected.image
        locationMarker?.iconView = nil
    }

    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        guard let place = locationMarker?.place else {
            Log.warning("No attached place on map marker")
            return
        }

        delegate?.lunchMapVCDidSelectPlace(self, place: place)
    }
}
