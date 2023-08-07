//
//  UIImageView+Extensions.swift
//  TheDogAPI
//
//  Created by Gustavo Quenca on 07/08/2023.
//

import UIKit

extension UIImageView {
    private struct Cache {
        static let image = NSCache<AnyObject, AnyObject>()
    }
    
    func setImageFromURL(_ urlString: String) {
        self.image = nil
        
        // Check cache for image
        if let cachedImage = Cache.image.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
    
        // Download image
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    if let image = UIImage(data: data!) {
                        Cache.image.setObject(image, forKey: urlString as AnyObject)
                        self.image = image
                    }
                }
                
            }.resume()
        }
    }
}
