//
//  Theme.swift
//  AllTrails
//
//  Created by Aryaman Sharda on 11/24/20.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    /// Loads an image from a URL and saves it into an image cache, returns the image if already available in the cache.
    /// - Parameter urlString: String representation of the URL to load the image from
    @discardableResult
    func loadImageFromURL(urlString: String) -> URLSessionDataTask? {
        self.image = nil

        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            self.image = cachedImage
            return nil
        }

        guard let url = URL(string: urlString) else {
            return nil
        }

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, _) in
            DispatchQueue.main.async {
                if let data = data, let downloadedImage = UIImage(data: data) {
                    imageCache.setObject(downloadedImage, forKey: NSString(string: urlString))
                    self.image = downloadedImage
                }
            }
        })

        task.resume()
        return task
    }
}
