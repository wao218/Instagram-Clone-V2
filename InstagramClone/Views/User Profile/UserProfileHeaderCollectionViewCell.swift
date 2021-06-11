//
//  UserProfileHeaderCollectionViewCell.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 5/20/21.
//

import UIKit

class UserProfileHeaderCollectionViewCell: UICollectionViewCell {
  // MARK: - MODEL
  var user: User? {
    didSet {
      guard let profileImageUrl = user?.profileImageUrl else { return }
      profileImageView.loadImage(urlString: profileImageUrl)
      usernameLabel.text = user?.username
    }
  }
  
  // MARK: - UI ELEMENTS
  let profileImageView: CustomImageView = {
    let imageView = CustomImageView()
    return imageView
  }()
  
  let gridButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "grid"), for: .normal)
    return button
  }()
  
  let listButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "list"), for: .normal)
    button.tintColor = UIColor(white: 0, alpha: 0.2)
    return button
  }()
  
  
  let bookmarkButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "ribbon"), for: .normal)
    button.tintColor = UIColor(white: 0, alpha: 0.2)
    return button
  }()
  
  let usernameLabel: UILabel = {
    let label = UILabel()
    label.text = "username"
    label.font = UIFont.boldSystemFont(ofSize: 14)
    return label
  }()
  
  let postsLabel: UILabel = {
    let label = UILabel()
    
    let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
    
    attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
    
    label.attributedText = attributedText
    
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  let followersLabel: UILabel = {
    let label = UILabel()
    
    let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
    
    attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
    
    label.attributedText = attributedText
    
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  let followingLabel: UILabel = {
    let label = UILabel()
    
    let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
    
    attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
    
    label.attributedText = attributedText
    
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  let editProfileButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Edit Profile", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.layer.borderColor = UIColor.lightGray.cgColor
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 3
    return button
  }()
  
  // MARK: - LIFE CYCLE METHODS
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(profileImageView)
    profileImageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, centerX: nil, centerY: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 0), size: .init(width: 80, height: 80))
    profileImageView.layer.cornerRadius = 80 / 2
    profileImageView.clipsToBounds = true
    
    setupBottomToolbar()
    
    addSubview(usernameLabel)
    usernameLabel.anchor(top: profileImageView.bottomAnchor, leading: self.leadingAnchor, bottom: gridButton.topAnchor, trailing: self.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 4, left: 12, bottom: 0, right: 12), size: .init(width: 0, height: 0))
    
    setupUserStats()
    
    addSubview(editProfileButton)
    editProfileButton.anchor(top: postsLabel.bottomAnchor, leading: postsLabel.leadingAnchor, bottom: nil, trailing: followingLabel.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 2, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 34))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - HELPER METHODS
  private func setupUserStats() {
    let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
    stackView.distribution = .fillEqually
    
    addSubview(stackView)
    
    stackView.anchor(top: self.topAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: self.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 12), size: .init(width: 0, height: 50))
  }
  
  private func setupBottomToolbar() {
    
    let topDividerView = UIView()
    topDividerView.backgroundColor = UIColor.lightGray
    
    let bottomDividerView = UIView()
    bottomDividerView.backgroundColor = UIColor.lightGray
    
    let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    
    addSubview(stackView)
    addSubview(topDividerView)
    addSubview(bottomDividerView)
    
    stackView.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 50))
    topDividerView.anchor(top: stackView.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0.5))
    bottomDividerView.anchor(top: stackView.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0.5))
  }
  
}
