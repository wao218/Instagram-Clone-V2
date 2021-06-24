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
      textLabel.text = comment?.text
    }
  }
  
  let textLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.numberOfLines = 0
    label.backgroundColor = .lightGray
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .yellow
    addSubview(textLabel)
    textLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 4, bottom: 4, right: 4))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
