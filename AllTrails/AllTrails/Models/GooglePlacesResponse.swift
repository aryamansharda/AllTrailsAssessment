//
//  GooglePlacesResponse.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import Foundation

// MARK: - GooglePlacesResponse
struct GooglePlacesResponse: Decodable {
    let candidates: [Candidate]
    let status: String
}

// MARK: - Candidate
struct Candidate: Decodable {
    let formattedAddress: String
    let geometry: Geometry
    let icon: String
    let name: String
    let openingHours: OpeningHours?
    let photos: [Photo]
    let rating: Double

    enum CodingKeys: String, CodingKey {
        case formattedAddress = "formatted_address"
        case geometry, icon, name
        case openingHours = "opening_hours"
        case photos, rating
    }
}

// MARK: - Geometry
struct Geometry: Decodable {
    let location: Location
//    let viewport: Viewport
}

// MARK: - Location
struct Location: Decodable {
    let lat, lng: Double
}

// MARK: - Viewport
struct Viewport: Decodable {
    let northeast, southwest: Location
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
    let htmlAttributions: [String]
    let photoReference: String
    let width: Int

    enum CodingKeys: String, CodingKey {
        case height
        case htmlAttributions = "html_attributions"
        case photoReference = "photo_reference"
        case width
    }
}
