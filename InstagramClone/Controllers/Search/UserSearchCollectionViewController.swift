//
//  UserSearchCollectionViewController.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/11/21.
//

import UIKit
import Firebase

class UserSearchCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  private let reuseIdentifier = "Cell"
  private var users = [User]()
  private var filteredUsers = [User]()
 
  // MARK: - UI Elements
  private lazy var searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "Enter username"
    searchBar.delegate = self
    return searchBar
  }()
  
  // MARK: LifeCycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Register cell classes
    self.collectionView!.register(UserSearchCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    
    
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceVertical = true
    collectionView.keyboardDismissMode = .onDrag
    
    let navBar = navigationController?.navigationBar
    navBar?.addSubview(searchBar)
    
    searchBar.anchor(top: navBar?.topAnchor, leading: navBar?.leadingAnchor, bottom: navBar?.bottomAnchor, trailing: navBar?.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8))
    
    fetchUsers()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchBar.isHidden = false
  }
  
  // MARK: - Helper Methods
  private func fetchUsers() {
    print("Fetching users....")
    
    let ref = Firebase.Database.database().reference().child("users")
    ref.observeSingleEvent(of: .value) { [weak self] snapshot in
      
      guard let dictionaries = snapshot.value as? [String: Any] else { return }
      
      dictionaries.forEach { (key, value) in
        if key == Firebase.Auth.auth().currentUser?.uid {
          print("Found myself omit from lits")
          return
        }
        
        guard let userDictionary = value as? [String: Any] else { return }
        let user = User(uid: key, dictionary: userDictionary)
        self?.users.append(user)
      }
      
      guard var users = self?.users else { return }
      
      users.sort { u1, u2 in
        return u1.username.compare(u2.username) == .orderedAscending
      }
      
      self?.filteredUsers = users
      self?.collectionView.reloadData()
    } withCancel: { error in
      print("Failed to fetch users for search: \(error)")
    }

  }
  
  
  // MARK: - UICollectionViewDataSource
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    return filteredUsers.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserSearchCollectionViewCell
    
    // Configure the cell
    cell.user = filteredUsers[indexPath.item]
    
    return cell
  }
  
  // MARK: - UICollectionViewDelegateFlowLayout
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 66)
  }
  
  // MARK: - UICollectionViewDelegate
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    searchBar.isHidden = true
    searchBar.resignFirstResponder()
    
    let user = filteredUsers[indexPath.item]
    print(user.username)
    
    let userProfileController = UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
    userProfileController.userId = user.uid
    navigationController?.pushViewController(userProfileController, animated: true)
    
  }
 
  
}

extension UserSearchCollectionViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    if searchText.isEmpty {
      filteredUsers = users
    } else {
      filteredUsers =  users.filter { user in
        return user.username.lowercased().contains(searchText.lowercased())
      }
    }
    
    self.collectionView.reloadData()
  }
}
