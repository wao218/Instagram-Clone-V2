//
//  CommentInputAccessoryView.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 7/2/21.
//

import UIKit

protocol CommentInputAccessoryViewDelegate {
  func didSubmit(for comment: String)
}


class CommentInputAccessoryView: UIView {
  
  var delegate: CommentInputAccessoryViewDelegate?
  
  private let submitButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Submit", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
    return button
  }()
  
  private let commentTextView: CommentInputTextView = {
    let textView = CommentInputTextView()
    textView.isScrollEnabled = false
    textView.font = UIFont.systemFont(ofSize: 18)
    return textView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
   
    autoresizingMask = .flexibleHeight
    
    backgroundColor = .white
    
    addSubview(submitButton)
    submitButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 12), size: .init(width: 50, height: 50))
    
    addSubview(commentTextView)
    commentTextView.anchor(top: topAnchor, leading: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: submitButton.leadingAnchor, padding: .init(top: 8, left: 12, bottom: 8, right: 0))
    
    setupLineSeparatorView()
   

  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var intrinsicContentSize: CGSize {
    return .zero
  }
  // MARK: - Helper Methods
  private func setupLineSeparatorView() {
    let lineSeparator = UIView()
    lineSeparator.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
    addSubview(lineSeparator)
    lineSeparator.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: .init(width: 0, height: 0.5))
  }
  
  func clearCommentTextView() {
    commentTextView.text = nil
    commentTextView.showPlaceholderText()
  }
  
  // MARK: - Action Methods
  @objc private func handleSubmit() {
    
    guard let commentText = commentTextView.text else { return }
    
    delegate?.didSubmit(for: commentText)
  }

}
