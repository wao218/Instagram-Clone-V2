//
//  MediaSelectorCollectionViewCell.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/3/21.
//

import UIKit

class MediaSelectorCollectionViewCell: UICollectionViewCell {
  
  let photoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.backgroundColor = .lightGray
    return imageView
  }()
 
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(photoImageView)
    photoImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, centerX: nil, centerY: nil, padding: .init(), size: .init())
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
