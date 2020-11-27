//
//  API.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import Foundation

final class NetworkManager {
    /// Builds the relevant URL components from the values specified in the API
    fileprivate class func buildURL(endpoint: API) -> URLComponents {
        var components = URLComponents()
        components.scheme = endpoint.scheme.rawValue
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        return components
    }

    /// Executes the web call and will decode the JSON response into the Codable object provided
    /// - Parameters:
    ///   - endpoint: the endpoint to make the HTTP request against
    ///   - completion: the JSON response converted to the provided Codable object, if successful, or failure otherwise
    class func request<T: Decodable>(endpoint: API, completion: @escaping (Result<T, Error>) -> Void) {
        let components = buildURL(endpoint: endpoint)
        guard let url = components.url else {
            Log.error("URL creation error")
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue

        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                Log.error("Unknown Error", error)
                return
            }

            guard response != nil, let data = data else {
                return
            }

            if let responseObject = try? JSONDecoder().decode(T.self, from: data) {
                completion(.success(responseObject))
            } else {
                let error = NSError(domain: "com.AllTrails", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])
                Log.error("Decode Error", error)
                completion(.failure(error))
            }
        }

        dataTask.resume()
    }
}
