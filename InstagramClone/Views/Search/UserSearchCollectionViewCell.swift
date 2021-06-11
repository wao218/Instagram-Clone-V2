//
//  UserSearchCollectionViewCell.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/11/21.
//

import UIKit

class UserSearchCollectionViewCell: UICollectionViewCell {
  var user: User? {
    didSet {
      usernameLabel.text = user?.username
      guard let profileImageUrl = user?.profileImageUrl else { return }
      profileImageView.loadImage(urlString: profileImageUrl)
    }
  }
  
  
  // MARK: - UI Elements
  private let profileImageView: CustomImageView = {
    let imageView = CustomImageView()
    imageView.backgroundColor = .red
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private let usernameLabel: UILabel = {
    let label = UILabel()
    label.text = "Username"
    label.font = UIFont.boldSystemFont(ofSize: 14)
    return label
  }()
  
  // MARK: - UI Functions
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(profileImageView)
    addSubview(usernameLabel)
    
    profileImageView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, centerX: nil, centerY: centerYAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 50, height: 50))
    profileImageView.layer.cornerRadius = 50 / 2
    
    usernameLabel.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 0))
    
    let separatorView = UIView()
    separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
    addSubview(separatorView)
    separatorView.anchor(top: nil, leading: usernameLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 0.5))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
