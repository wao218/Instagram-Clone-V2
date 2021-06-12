//
//  HomePostCollectionViewCell.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/7/21.
//

import UIKit

class HomePostCollectionViewCell: UICollectionViewCell {
  
  var post: Post? {
    didSet {
      guard let mediaUrl = post?.mediaUrl else { return }
      postImageView.loadImage(urlString: mediaUrl)

      guard let username = post?.user.username else { return }
      guard let profileImageUrl = post?.user.profileImageUrl else { return }
      
      usernameLabel.text = username
      profileImageView.loadImage(urlString: profileImageUrl)
      
      setupAttributedCaption()
    }
  }
  
  
  // MARK: - UI Elements
  private let postImageView: CustomImageView = {
    let imageView = CustomImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private let profileImageView: CustomImageView = {
    let imageView = CustomImageView()
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
  
  private let optionsButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("•••", for: .normal)
    button.setTitleColor(.black, for: .normal )
    return button
  }()
  
  private let likeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
 
  private let commentButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  private let sendMessageButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "send2")?.withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  private let saveButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  private let captionLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  
  // MARK: - UI Functions
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(profileImageView)
    addSubview(usernameLabel)
    addSubview(optionsButton)
    addSubview(postImageView)
    
    profileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 8, bottom: 0, right: 0), size: .init(width: 40, height: 40))
    profileImageView.layer.cornerRadius = 40 / 2
    
    usernameLabel.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: postImageView.topAnchor, trailing: optionsButton.leadingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 0))
    
    optionsButton.anchor(top: topAnchor, leading: nil, bottom: postImageView.topAnchor, trailing: trailingAnchor, size: .init(width: 44, height: 0))
    
    postImageView.anchor(top: profileImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
    postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
    
    setupActionButtons()
    
    addSubview(captionLabel)
    captionLabel.anchor(top: likeButton.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helper Methods
  private func setupActionButtons() {
    let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
    stackView.distribution = .fillEqually
    
    addSubview(stackView)
    stackView.anchor(top: postImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 120, height: 50))
    
    addSubview(saveButton)
    saveButton.anchor(top: postImageView.bottomAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, size: .init(width: 40, height: 50))
  }
  
  private func setupAttributedCaption() {
    guard let post = self.post else { return }
    let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
    
    attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
    
    attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
    
    let timeAgoDisplay = post.creationDate.timeAgoDisplay()
    attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
    
    captionLabel.attributedText = attributedText
  }
  
}
