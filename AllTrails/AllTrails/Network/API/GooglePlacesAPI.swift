//
//  GooglePlacesAPI.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import Foundation

enum GooglePlacesAPI: API {
    case getPlacesResults(searchText: String)

    var scheme: HTTPScheme {
        switch self {
        case .getPlacesResults:
            return .https
        }
    }

    var baseURL: String {
        switch self {
        case .getPlacesResults:
            return "maps.googleapis.com"
        }
    }

    var path: String {
        switch self {
        case .getPlacesResults:
            return "/maps/api/place/findplacefromtext/json"
        }
    }

    var parameters: [URLQueryItem] {
        let apiKey = "AIzaSyDIKzjfQQCahwJ9yEr8gBU9TqJ3MvbPXyY"

        switch self {
        case .getPlacesResults(let query):
            return [
                URLQueryItem(name: "fields", value: "photos,formatted_address,name,rating,opening_hours,geometry,icon"),
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "input", value: query),
                URLQueryItem(name: "inputtype", value: "textquery"),
                URLQueryItem(name: "type", value: "restaurant"),
                URLQueryItem(name: "language", value: Locale.current.languageCode)
            ]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getPlacesResults:
            return .get
        }
    }
}
