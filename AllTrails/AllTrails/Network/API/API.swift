//
//  API.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import Foundation

/// The API protocol allows us to seperate the task of constructing a URL and it's associated parameters and HTTP method from the act of executing the URL request
/// and parsing the response
protocol API {
    /// .http  or .https
    var scheme: HTTPScheme { get }

    // Example: "maps.googleapis.com"
    var baseURL: String { get }

    // "/maps/api/place/findplacefromtext/"
    var path: String { get }

    // [URLQueryItem(name: "api_key", value: API_KEY)]
    var parameters: [URLQueryItem] { get }

    // "GET"
    var method: HTTPMethod { get }
}

enum HTTPMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

enum HTTPScheme: String {
    case http
    case https
}
