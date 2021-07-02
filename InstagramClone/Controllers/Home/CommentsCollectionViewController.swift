//
//  CommentsCollectionViewController.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/17/21.
//

import UIKit
import Firebase

class CommentsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CommentInputAccessoryViewDelegate {
  
  var post: Post?
  var comments = [Comment]()
  private let reuseIdentifier = "cellID"
  
  // MARK: - UI Elements
  private lazy var containerView: CommentInputAccessoryView = {
    
    let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
    let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
    commentInputAccessoryView.delegate = self
    return commentInputAccessoryView
  }()
  
  
  
  // MARK: - LifeCycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Register cell classes
    self.collectionView!.register(CommentsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    
    navigationItem.title = "Comments"
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceVertical = true
    collectionView.keyboardDismissMode = .interactive
    
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
      guard let uid = dictionary["uid"] as? String else { return }
      
      Firebase.Database.fetchUserWithUID(uid: uid) { user in
        let comment = Comment(user: user, dictionary: dictionary)
        self?.comments.append(comment)
        self?.collectionView.reloadData()
      }
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
  
  // MARK: - CommentInputAccessoryViewDelegate
  func didSubmit(for comment: String) {
    print("Trying to insert a comment into firebase")
    
    guard let uid = Firebase.Auth.auth().currentUser?.uid else { return }
    print("post id:", self.post?.id ?? "")
    print("Inserting comment:", comment)

    let postId = self.post?.id ?? ""
    let values = [
      "text": comment,
      "creationDate": Date().timeIntervalSince1970,
      "uid": uid
    ] as [String : Any]
    Firebase.Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { [weak self] error, ref in
      guard error == nil else {
        print("Failed to insert comment:", error ?? "")
        return
      }

      print("successfully inserted comment")
      
      self?.containerView.clearCommentTextView()
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
    let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
    let dummyCell = CommentsCollectionViewCell(frame: frame)
    dummyCell.comment = comments[indexPath.item]
    dummyCell.layoutIfNeeded()
    
    let targetSize = CGSize(width: view.frame.width, height: 1000)
    let estimatedSzie = dummyCell.systemLayoutSizeFitting(targetSize)
    
    let height = max(40 + 8 + 8, estimatedSzie.height)
    
    return CGSize(width: view.frame.width, height: height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  // MARK: - UICollectionViewDelegate
  
 
  
}
