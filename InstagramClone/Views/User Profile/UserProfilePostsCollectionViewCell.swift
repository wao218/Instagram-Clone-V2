//
//  UserProfilePostsCollectionViewCell.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/7/21.
//

import UIKit

class UserProfilePostsCollectionViewCell: UICollectionViewCell {
  
  var post: Post? {
    didSet {
      guard let mediaUrl = post?.mediaUrl else { return }
      imageView.loadImage(urlString: mediaUrl)
    }
  }
  
  let imageView: CustomImageView = {
    let imageView = CustomImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
    
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(imageView)
    imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, centerX: nil, centerY: nil, padding: .init(), size: .init())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
