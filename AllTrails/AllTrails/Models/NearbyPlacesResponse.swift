//
//  NearbyPlacesResponse.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import Foundation

// MARK: - NearbyPlacesResponse
struct NearbyPlacesResponse: Decodable {
    let results: [Place]
}

// MARK: - Result
struct Place: Decodable {
    let geometry: Geometry
    let icon: String
    let id: String?
    let name: String
    let openingHours: OpeningHours?
    let photos: [Photo]
    let placeID, reference: String
    let types: [String]
    let vicinity: String

    enum CodingKeys: String, CodingKey {
        case geometry, icon, id, name
        case openingHours = "opening_hours"
        case photos
        case placeID = "place_id"
        case reference, types, vicinity
    }
}

// MARK: - Geometry
struct Geometry: Decodable {
    let location: Location
}

// MARK: - Location
struct Location: Decodable {
    let lat, lng: Double
}

// MARK: - OpeningHours
struct OpeningHours: Decodable {
    let openNow: Bool

    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}

// MARK: - Photo
struct Photo: Decodable {
    let height: Int
    let photoReference: String
    let width: Int

    enum CodingKeys: String, CodingKey {
        case height
        case photoReference = "photo_reference"
        case width
    }
}
