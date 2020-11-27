//
//  ATMapMarker.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/26/20.
//

import Foundation
import GoogleMaps
import UIKit

final class ATMapMarker: GMSMarker {
    let place: Place

    init(place: Place, mapView: GMSMapView) {
        self.place = place
        super.init()

        icon = Asset.Assets.markerUnselected.image
        map = mapView
        appearAnimation = .pop
        position = CLLocationCoordinate2D(latitude: place.geometry.location.lat,
                                          longitude: place.geometry.location.lng)
    }
}
