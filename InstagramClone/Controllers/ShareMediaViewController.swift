//
//  ShareMediaViewController.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/4/21.
//

import UIKit

class ShareMediaViewController: UIViewController {
  
  var selectedImage: UIImage? {
    didSet {
      self.imageView.image = selectedImage
    }
  }
  
  // MARK: - UI ELEMENTS
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .red
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  let textView: UITextView = {
    let textView = UITextView()
    textView.font = UIFont.systemFont(ofSize: 14)
    return textView
  }()
  
  // MARK: - LIFECYCLE METHODS
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
    
    setupImageandTextViews()
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  
  // MARK: - HELPER METHODS
  private func setupImageandTextViews() {
    let containerView = UIView()
    containerView.backgroundColor = .white
    view.addSubview(containerView)
    containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(), size: .init(width: 0, height: 100))
    
    containerView.addSubview(imageView)
    imageView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: nil, centerX: nil, centerY: nil, padding: .init(top: 8, left: 8, bottom: 8, right: 0), size: .init(width: 84, height: 0))
    
    containerView.addSubview(textView)
    textView.anchor(top: containerView.topAnchor, leading: imageView.trailingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(), size: .init())
  }
  
  // MARK: - ACTION METHODS
  @objc private func handleShare() {
    print("handle share")
  }
  
}
