//
//  GooglePlacesAPI.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import Foundation

enum GooglePlacesAPI: API {
    case getNearbyPlaces(searchText: String)

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
        let apiKey = "AIzaSyDIKzjfQQCahwJ9yEr8gBU9TqJ3MvbPXyY"

        switch self {
        case .getNearbyPlaces(let query):
            print(query)
            return [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "location", value: "37.773972, -122.431297"),
                URLQueryItem(name: "keyword", value: "pizza"),
                URLQueryItem(name: "language", value: Locale.current.languageCode),
                URLQueryItem(name: "rankby", value: "distance")
            ]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getNearbyPlaces:
            return .get
        }
    }
}
