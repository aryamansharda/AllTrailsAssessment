//
//  Secrets.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/26/20.
//

import Foundation

internal enum Secrets {
    static var googlePlacesAPIKey: String {
        return loadKeyFromPlist(key: "GOOGLE_API_KEY")
    }

    fileprivate static func loadKeyFromPlist(key: String) -> String {
        guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
          fatalError("Couldn't find file 'Secrets.plist'.")
        }

        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: key) as? String else {
          fatalError("Couldn't find key '\(key)' in 'Secrets.plist'.")
        }

        return value
    }
}
