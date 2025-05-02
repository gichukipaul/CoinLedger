//
//  Utlities.swift
//  CoinLedger
//
//  Created by GICHUKI on 29/04/2025.
//

import UIKit

/// Image loader with Caching to support quick loading of already visited icons.
final class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cached = cache.object(forKey: urlString as NSString) {
            completion(cached)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            self?.cache.setObject(image, forKey: urlString as NSString)
            completion(image)
        }.resume()
    }
}

/// Some Icon have  iconURLs with the SVG format, and that image format is not directly compatible with the ImageView
/// Fortunalte the URLS also work when you change the .svg part with .png, which is directly compatibel without using 3rd partiy libraries.
func iconURLToPNG(from url: String) -> String {
    if url.hasSuffix(".svg") {
        return url.replacingOccurrences(of: ".svg", with: ".png")
    }
    return url
}
