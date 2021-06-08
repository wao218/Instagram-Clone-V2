//
//  CustomImageView.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/7/21.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
  
  var lastURLUsedToLoadImage: String?
  
  func loadImage(urlString: String) {
    
    lastURLUsedToLoadImage = urlString
    
    if let cachedImage = imageCache[urlString] {
      self.image = cachedImage
      return
    }
    
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
      guard error == nil else {
        print("Failed to fetch post: ", error ?? "")
        return
      }
      
      if url.absoluteString != self?.lastURLUsedToLoadImage { return }
      
      guard let mediaData = data else { return }
      
      let image = UIImage(data: mediaData)
      
      imageCache[url.absoluteString] = image
      
      DispatchQueue.main.async {
        self?.image = image
      }
      
    }.resume()
  }
}
