//
//  GooglePlacesAPI.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import Foundation

enum GooglePlacesAPI: API {
    case getNearbyPlaces(searchText: String?)

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
        case .getNearbyPlaces(let query):
            var params = [
                URLQueryItem(name: "key", value: GooglePlacesAPI.key),
                URLQueryItem(name: "location", value: "37.773972, -122.431297"),
                URLQueryItem(name: "language", value: Locale.current.languageCode),
                URLQueryItem(name: "rankby", value: "distance"),
                URLQueryItem(name: "type", value: "restaurant")
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
