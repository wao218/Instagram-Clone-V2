//
//  CommentInputTextView.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 7/2/21.
//

import UIKit

class CommentInputTextView: UITextView {

  private let placeHolderLabel: UILabel = {
    let label = UILabel()
    label.text = "Enter Comment"
    label.textColor = .lightGray
    return label
  }()
  
  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
    
    addSubview(placeHolderLabel)
    placeHolderLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 0))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func handleTextChange() {
    placeHolderLabel.isHidden = !self.text.isEmpty
  }
  
  func showPlaceholderText() {
    placeHolderLabel.isHidden = false
  }
}
