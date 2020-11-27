//
//  GooglePlacesAPI.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import Foundation

enum GooglePlacesAPI: API {
    case getNearbyPlaces(searchText: String?, latitude: Double, longitude: Double)

    var scheme: HTTPScheme {
        switch self {
        case .getNearbyPlaces:
            return .https
        }
    }

    var baseURL: String {
        switch self {
        case .getNearbyPlaces:
            return "maps.googleapis.com"
        }
    }

    var path: String {
        switch self {
        case .getNearbyPlaces:
            return "/maps/api/place/nearbysearch/json"
        }
    }

    var parameters: [URLQueryItem] {
        switch self {
        case .getNearbyPlaces(let query, let latitude, let longitude):
            var params = [
                URLQueryItem(name: "key", value: GooglePlacesAPI.key),
                URLQueryItem(name: "language", value: Locale.current.languageCode),
                URLQueryItem(name: "type", value: "restaurant"),
                URLQueryItem(name: "radius", value: "6500"),
                URLQueryItem(name: "location", value: "\(latitude),\(longitude)")
            ]

            if let query = query {
                params.append(URLQueryItem(name: "keyword", value: query))
            }
            return params
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getNearbyPlaces:
            return .get
        }
    }
}

extension GooglePlacesAPI {
    static func generatePhotoURL(from photoReference: String) -> String {
        "https://maps.googleapis.com/maps/api/place/photo?key=\(key)&maxwidth=100&photoreference=\(photoReference)"
    }

    static var key: String {
        "AIzaSyDIKzjfQQCahwJ9yEr8gBU9TqJ3MvbPXyY"
    }
}
