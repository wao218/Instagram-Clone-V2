//
//  HomeCollectionViewController.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/7/21.
//

import UIKit
import Firebase

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

  var posts = [Post]()
  private let reuseIdentifier = "Cell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    // Register cell classes
    self.collectionView!.register(HomePostCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    
    collectionView?.backgroundColor = .white
    
    setupNavigationItems()
    
    fetchPosts()
  }
  
  // MARK: - Helper Methods
  private func setupNavigationItems() {
    navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
  }
  
  private func fetchPosts() {
    guard let uid = Firebase.Auth.auth().currentUser?.uid else { return }
    
    Firebase.Database.database().reference().child("users/\(uid)").observeSingleEvent(of: .value) { snapshot in
      guard let userDictionary = snapshot.value as? [String: Any] else { return }
      let user = User(dictionary: userDictionary)
      
      
      let ref = Firebase.Database.database().reference().child("posts/\(uid)")
      ref.observeSingleEvent(of: .value) { [weak self] (snapshot) in
        
        guard let dictionaries = snapshot.value as? [String: Any] else { return }
        
        dictionaries.forEach { (key, value) in
          
          guard let dictionary = value as? [String: Any] else { return }
          
          let post = Post(user: user, dictionary: dictionary)
          
          print(post.mediaUrl)
          self?.posts.append(post)
        }
        
        self?.collectionView.reloadData()
        
      } withCancel: { error in
        print("Failed to fetch posts: ", error)
      }
      
    } withCancel: { error in
      print("Failed to fetch user for posts: \(error)")
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
    
    return cell
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
  
  // MARK: - UICollectionViewDelegateFlowLayout
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    var height: CGFloat = 40 + 8 + 8 // username label size plus top and bottom padding
    height += view.frame.width // space for square image view
    height += 50 // space for post buttons
    height += 60 // space for post caption
    
    
    return CGSize(width: view.frame.width, height: height)
  }
  
}

