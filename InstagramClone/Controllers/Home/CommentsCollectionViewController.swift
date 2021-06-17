//
//  CommentsCollectionViewController.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/17/21.
//

import UIKit

private let reuseIdentifier = "Cell"

class CommentsCollectionViewController: UICollectionViewController {
  
  // MARK: - UI Elements
  private var containerView: UIView = {
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
    
    let textField = UITextField()
    textField.placeholder = "Enter comment"
    containerview.addSubview(textField)
    textField.anchor(top: containerview.topAnchor, leading: containerview.leadingAnchor, bottom: containerview.bottomAnchor, trailing: submitButton.leadingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 0))
    return containerview
  }()
  
  
  // MARK: - LifeCycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Register cell classes
    self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    
    navigationItem.title = "Comments"
    
    collectionView.backgroundColor = .red
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    tabBarController?.tabBar.isHidden = false
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
    print("handling submit.... ")
  }
  
  // MARK: - UICollectionViewDataSource
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 0
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    return 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
    // Configure the cell
    
    return cell
  }
  
  // MARK: UICollectionViewDelegate
  
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
