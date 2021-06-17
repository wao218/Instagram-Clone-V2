//
//  HomeCollectionViewController.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/7/21.
//

import UIKit
import Firebase

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
  
  var posts = [Post]()
  private let reuseIdentifier = "Cell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: ShareMediaViewController.updateFeedNotifcationName, object: nil)
    
    // Register cell classes
    self.collectionView!.register(HomePostCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    
    collectionView?.backgroundColor = .white
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    collectionView.refreshControl = refreshControl
    
    setupNavigationItems()
    
    fetchAllPosts()
  }
  
  // MARK: - Helper Methods
  @objc private func handleUpdateFeed() {
    handleRefresh()
  }
  
  @objc private func handleRefresh() {
    print("Handling refresh....")
    posts.removeAll()
    fetchAllPosts()
  }
  
  private func fetchAllPosts() {
    fetchPosts()
    fetchFollowingUserIds()
  }
  
  private func fetchFollowingUserIds() {
    guard let uid = Firebase.Auth.auth().currentUser?.uid else { return }
    Firebase.Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value) { [weak self] snapshot in
      
      guard let userDictionary = snapshot.value as? [String: Any] else { return }
      userDictionary.forEach { (key, value) in
        Firebase.Database.fetchUserWithUID(uid: key) { user in
          self?.fetchPostsWithUser(user: user)
        }
      }
      
    } withCancel: { error in
      print("Failed to fetch following users uid: ", error)
    }
  }
  private func setupNavigationItems() {
    navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera3")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
  }
  
  @objc private func handleCamera() {
    print("Showing camera")
    let cameraController = CameraViewController()
    cameraController.modalPresentationStyle = .fullScreen
    present(cameraController, animated: true, completion: nil)
  }
  
  private func fetchPosts() {
    guard let uid = Firebase.Auth.auth().currentUser?.uid else { return }
    
    Firebase.Database.fetchUserWithUID(uid: uid) { [weak self] user in
      self?.fetchPostsWithUser(user: user)
    }
    
  }
  
  private func fetchPostsWithUser(user: User) {
    
    let ref = Firebase.Database.database().reference().child("posts/\(user.uid)")
    ref.observeSingleEvent(of: .value) { [weak self] (snapshot) in
      self?.collectionView.refreshControl?.endRefreshing()
      
      guard let dictionaries = snapshot.value as? [String: Any] else { return }
      
      dictionaries.forEach { (key, value) in
        guard let dictionary = value as? [String: Any] else { return }
        let post = Post(user: user, dictionary: dictionary)
        print(post.mediaUrl)
        self?.posts.append(post)
      }
      
      self?.posts.sort(by: { p1, p2 in
        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
      })
      
      self?.collectionView.reloadData()
      
    } withCancel: { error in
      print("Failed to fetch posts: ", error)
    }
    
  }
  
  // MARK: - UICollectionViewDataSource
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomePostCollectionViewCell
    
    // Configure the cell
    cell.post = posts[indexPath.item]
    cell.delegate = self
    
    return cell
  }
  
  // MARK: - HomePostCellDelegate
  func didTapComment(post: Post ) {
    print("Message coming from HomeController")
    print(post.caption)
    let commentController = CommentsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    navigationController?.pushViewController(commentController, animated: true)
  }
  
  // MARK: - UICollectionViewDelegate
  
  
  
  // MARK: - UICollectionViewDelegateFlowLayout
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    var height: CGFloat = 40 + 8 + 8 // username label size plus top and bottom padding
    height += view.frame.width // space for square image view
    height += 50 // space for post buttons
    height += 60 // space for post caption
    
    
    return CGSize(width: view.frame.width, height: height)
  }
  
}

