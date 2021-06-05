//
//  ShareMediaViewController.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/4/21.
//

import UIKit
import Firebase

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
  
  private func saveToDatabaseWithUrl(url: String) {
    guard let postImage = selectedImage else { return }
    guard let caption = textView.text else { return }
    guard let uid = Firebase.Auth.auth().currentUser?.uid else { return }
    
    let userPostRef = Firebase.Database.database().reference().child("posts").child(uid)
    let ref = userPostRef.childByAutoId()
    let values = [
      "url": url,
      "caption": caption,
      "imageWidth": postImage.size.width,
      "imageHeight": postImage.size.height,
      "creationDate": Date().timeIntervalSince1970
    ] as [String : Any]
    
    ref.updateChildValues(values) { [weak self] (error, ref) in
      guard error == nil else {
        self?.navigationItem.rightBarButtonItem?.isEnabled = true
        print("Failed to save post to db: ", error ?? "")
        return
      }
      
      print("Successfully saved post to db.")
      self?.dismiss(animated: true, completion: nil)
    }
  }
  
  // MARK: - ACTION METHODS
  @objc private func handleShare() {
    guard let image = selectedImage else { return }
    
    guard let uploadDate = image.jpegData(compressionQuality: 0.5) else { return }
    
    navigationItem.rightBarButtonItem?.isEnabled = false
    
    let filename = NSUUID().uuidString
    Firebase.Storage.storage().reference().child("posts/\(filename)").putData(uploadDate, metadata: nil) { [weak self] (metadata, error) in
      
      guard error == nil else {
        self?.navigationItem.rightBarButtonItem?.isEnabled = true
        print("Failed to upload post: ", error ?? "")
        return
      }
      
      Firebase.Storage.storage().reference().child("posts/\(filename)").downloadURL { [weak self] (url, error) in
        guard error == nil else {
          self?.navigationItem.rightBarButtonItem?.isEnabled = true
          return
        }
        
        guard let url = url else {
          print("Failed to get download url: ", error ?? "")
          return
        }
        
        let urlString = url.absoluteString
        print("Successfully uploaded image: ", urlString)
        
        self?.saveToDatabaseWithUrl(url: urlString)
        
      }
      
    }
  }
  
}
