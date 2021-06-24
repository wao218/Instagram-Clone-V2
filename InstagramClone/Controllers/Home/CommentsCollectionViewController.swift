//
//  CommentsCollectionViewController.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/17/21.
//

import UIKit
import Firebase

class CommentsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
  var post: Post?
  var comments = [Comment]()
  private let reuseIdentifier = "cellID"
  
  // MARK: - UI Elements
  private lazy var containerView: UIView = {
    let containerview = UIView()
    containerview.backgroundColor = .white
    containerview.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
    
    let submitButton = UIButton(type: .system)
    submitButton.setTitle("Submit", for: .normal)
    submitButton.setTitleColor(.black, for: .normal)
    submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
    containerview.addSubview(submitButton)
    submitButton.anchor(top: containerview.topAnchor, leading: nil, bottom: containerview.bottomAnchor, trailing: containerview.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 12), size: .init(width: 50, height: 0))
    
  
    containerview.addSubview(commentTextField)
    commentTextField.anchor(top: containerview.topAnchor, leading: containerview.leadingAnchor, bottom: containerview.bottomAnchor, trailing: submitButton.leadingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 0))
    return containerview
  }()
  
  private let commentTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Enter comment"
    return textField
  }()
  
  // MARK: - LifeCycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Register cell classes
    self.collectionView!.register(CommentsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    
    navigationItem.title = "Comments"
    
    collectionView.backgroundColor = .red
    
    fetchComments()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    tabBarController?.tabBar.isHidden = false
  }
  
  
  // MARK: - Helper Methods
  private func fetchComments() {
    guard let postId = self.post?.id else { return }
    let ref = Firebase.Database.database().reference().child("comments").child(postId)
    ref.observe(.childAdded) { [weak self] snapshot in
      guard let dictionary = snapshot.value as? [String: Any] else { return }
      let comment = Comment(dictionary: dictionary)
      self?.comments.append(comment)
      self?.collectionView.reloadData()
    } withCancel: { error in
      print("failed to observe comments")
    }

  }
  
  // MARK: - Other Methods
  override var inputAccessoryView: UIView? {
    get {
      return containerView
    }
  }
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
  
  // MARK: - Action Methods
  @objc private func handleSubmit() {
    guard let uid = Firebase.Auth.auth().currentUser?.uid else { return }
    print("post id:", self.post?.id ?? "")
    print("Inserting comment:", commentTextField.text ?? "")
    
    let postId = self.post?.id ?? ""
    let values = [
      "text": commentTextField.text ?? "",
      "creationDate": Date().timeIntervalSince1970,
      "uid": uid
    ] as [String : Any]
    Firebase.Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { error, ref in
      guard error == nil else {
        print("Failed to insert comment:", error ?? "")
        return
      }
      
      print("successfully inserted comment")
    }
  }
  
  // MARK: - UICollectionViewDataSource
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    return comments.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentsCollectionViewCell
    
    // Configure the cell
    cell.comment = comments[indexPath.item]
    return cell
  }
  
  
  // MARK: - UICollectionViewDelegateFlowLayout
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 50)
  }
  
  // MARK: - UICollectionViewDelegate
  
  /*
   // Uncomment this method to specify if the specified item should be highlighted during tracking
   override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
   return true
   }
   */
  
  /*
   // Uncomment this method to specify if the specified item should be selected
   override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
   return true
   }
   */
  
  /*
   // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
   override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
   return false
   }
   
   override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
   return false
   }
   
   override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
   
   }
   */
  
}
