//
//  UserProfileViewController.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 5/20/21.
//

import UIKit
import Firebase

class UserProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
  var user: User?
  
  let cellId = "cellId"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView?.backgroundColor = .white
    
    navigationItem.title = Firebase.Auth.auth().currentUser?.uid
    
    fetchUser()
    
    collectionView?.register(UserProfileHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
    
    collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 7
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    
    cell.backgroundColor = .purple
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (view.frame.width - 2) / 3
    return CGSize(width: width, height: width)
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
    
    return header
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: view.frame.width, height: 200)
  }
  
  fileprivate func fetchUser() {
    
    guard let uid = Firebase.Auth.auth().currentUser?.uid else { return }
    
    Firebase.Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { [weak self] (snapshot) in
      print(snapshot.value ?? "")
      
      guard let dictionary = snapshot.value as? [String: Any] else { return }
      
      self?.user = User(dictionary: dictionary)
      
      self?.navigationItem.title = self?.user?.username
      
      self?.collectionView.reloadData()
      
    } withCancel: { (error) in
      print("Failed to fetch user: ", error)
    }

  }
}
