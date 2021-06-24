//
//  CommentsCollectionViewCell.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/21/21.
//

import UIKit

class CommentsCollectionViewCell: UICollectionViewCell {
  var comment: Comment? {
    didSet {
      guard let comment = comment else { return }
      
      let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
      
      attributedText.append(NSAttributedString(string: " \(comment.text)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
      
      textView.attributedText = attributedText
      profileImageView.loadImage(urlString: comment.user.profileImageUrl)
    }
  }
  
  let textView: UITextView = {
    let textView = UITextView()
    textView.font = UIFont.systemFont(ofSize: 14)
    textView.isScrollEnabled = false
    return textView
  }()
  
  let profileImageView: CustomImageView = {
    let imageView = CustomImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = .blue
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    
    addSubview(profileImageView)
    profileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 8, bottom: 0, right: 0), size: .init(width: 40, height: 40))
    profileImageView.layer.cornerRadius = 40 / 2
    
    addSubview(textView)
    textView.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 4, bottom: 4, right: 4))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
