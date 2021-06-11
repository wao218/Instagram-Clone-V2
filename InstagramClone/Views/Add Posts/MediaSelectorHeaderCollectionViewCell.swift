//
//  MediaHeaderCollectionViewCell.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/3/21.
//

import UIKit

class MediaSelectorHeaderCollectionViewCell: UICollectionViewCell {
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.backgroundColor = .cyan
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
