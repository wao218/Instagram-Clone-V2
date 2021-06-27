//
//  UserProfileViewController.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 5/20/21.
//

import UIKit
import Firebase

class UserProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
  
  var user: User?
  var posts = [Post]()
  var isFinishedPaging = false
  
  let cellId = "cellId"
  let homePostCellId = "homePostCellId"
  var userId: String?
  
  var isGridView = true
  
  // MARK: - LIFECYCLE METHODS
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView?.backgroundColor = .white
    
    collectionView?.register(UserProfileHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
    
    collectionView?.register(UserProfilePostsCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    collectionView?.register(HomePostCollectionViewCell.self, forCellWithReuseIdentifier: homePostCellId)
    
    fetchUser()
    setupLogOutButton()
//    fetchOrderedPosts()
  }
  
  // MARK: - COLLECTION VIEW DELEGATE FUNCTIONS
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if indexPath.item == self.posts.count - 1 && !isFinishedPaging {
      print("paging for posts")
      paginatePosts()
    }
    
    if isGridView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePostsCollectionViewCell
      cell.post = posts[indexPath.item]
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as! HomePostCollectionViewCell
      cell.post = posts[indexPath.item]
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if isGridView {
      let width = (view.frame.width - 2) / 3
      return CGSize(width: width, height: width)
    } else {
      var height: CGFloat = 40 + 8 + 8 // username label size plus top and bottom padding
      height += view.frame.width // space for square image view
      height += 50 // space for post buttons
      height += 60 // space for post caption
      return CGSize(width: view.frame.width, height: height)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeaderCollectionViewCell
    
    header.user = self.user
    header.delegate = self
    return header
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: view.frame.width, height: 200)
  }
  
  // MARK: - HELPER METHODS
  private func paginatePosts() {
    print("start paging for more posts")
    
    guard let uid = self.user?.uid else { return }
    let ref = Firebase.Database.database().reference().child("posts").child(uid)
    var query = ref.queryOrderedByKey()
    
    if posts.count > 0 {
      let value = posts.last?.id
      query = query.queryStarting(atValue: value)
    }
    
    query.queryLimited(toFirst: 4).observeSingleEvent(of: .value) { [weak self] snapshot in
      
      guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
      if allObjects.count < 4 {
        self?.isFinishedPaging = true
      }
      if let postCount = self?.posts.count, postCount > 0 {
        allObjects.removeFirst()
      }
      
      guard let user = self?.user else { return }
      allObjects.forEach({ snapshot in
        guard let dictionary = snapshot.value as? [String: Any] else { return }
        var post = Post(user: user, dictionary: dictionary)
        post.id = snapshot.key
        self?.posts.append(post)
      })
      
      self?.posts.forEach({ post in
        print(post.id ?? "")
      })
      
      self?.collectionView.reloadData()
    } withCancel: { error in
      print("Failed to paginate posts:", error)
    }

  }
  
  private func fetchOrderedPosts() {
    guard let uid = user?.uid else { return }
    let ref = Firebase.Database.database().reference().child("posts/\(uid)")
    
    ref.queryOrdered(byChild: "creationDate").observe(.childAdded) { [weak self] (snapshot) in
      guard let dictionary = snapshot.value as? [String: Any] else { return }
      
      guard let user = self?.user else { return }
      let post = Post(user: user, dictionary: dictionary)
      
      self?.posts.insert(post, at: 0)
      
      self?.collectionView.reloadData()
      
    } withCancel: { (error) in
      print("Failed to fetch ordered posts: ", error)
    }

  }
  
  private func fetchUser() {
    
    let uid = userId ?? Firebase.Auth.auth().currentUser?.uid ?? ""
    
    Firebase.Database.fetchUserWithUID(uid: uid) { [weak self] user in
      self?.user = user
      self?.navigationItem.title = self?.user?.username
      self?.collectionView.reloadData()
      self?.paginatePosts()
    }
  }
  
  private func setupLogOutButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
  }
  
  // MARK: - ACTION METHODS
  @objc private func handleLogOut() {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
      
      do {
        try Firebase.Auth.auth().signOut()
        let loginVC = LoginViewController()
        let navVC = UINavigationController(rootViewController: loginVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
      } catch let error {
        print("Failed to sign out: ", error)
      }
      
    }))
    
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    present(alertController, animated: true, completion: nil)
  }
  
  // MARK: - UserProfileHeaderDelegate
  func didChangeToGridView() {
    isGridView = true
    collectionView.reloadData()
  }
  
  func didChangeToListView() {
    isGridView = false
    collectionView.reloadData()
  }
}
