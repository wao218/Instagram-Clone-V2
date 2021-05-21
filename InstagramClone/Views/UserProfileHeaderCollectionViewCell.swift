//
//  UserProfileHeaderCollectionViewCell.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 5/20/21.
//

import UIKit

class UserProfileHeaderCollectionViewCell: UICollectionViewCell {
  
  var user: User? {
    didSet {
      setupProfileImage()
    }
  }
  
  let profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .red
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .blue
    
    addSubview(profileImageView)
    profileImageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, centerX: nil, centerY: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 0), size: .init(width: 80, height: 80))
    profileImageView.layer.cornerRadius = 80 / 2
    profileImageView.clipsToBounds = true
    
    setupProfileImage()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  fileprivate func setupProfileImage() {
    guard let profileImageUrl = user?.profileImageUrl else { return }
    
    guard let url = URL(string: profileImageUrl) else { return }
    
    URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
      // check for the error, then construct the image using data
      guard error == nil else {
        print("Failed to fetch profile image: ", error ?? "")
        return
      }
      
      guard let data = data else { return }
      
      DispatchQueue.main.async {
        self?.profileImageView.image = UIImage(data: data)
      }
      
    }.resume()
  }
}
