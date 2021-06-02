//
//  MainTabBarViewController.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 5/20/21.
//

import UIKit
import Firebase

class MainTabBarViewController: UITabBarController {
  
  // MARK: LIFECYCLE METHODS
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if Firebase.Auth.auth().currentUser == nil {
      DispatchQueue.main.async {
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
      }
      
      return
    }
    
    setupViewControllers()
    
  }
  
  // MARK: - HELPER METHODS
  func setupViewControllers() {
    let layout = UICollectionViewFlowLayout()
    let userProfileVC = UserProfileViewController(collectionViewLayout: layout)
    
    let navController = UINavigationController(rootViewController: userProfileVC)
    
    navController.tabBarItem.image = UIImage(named: "profile_unselected")
    navController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
    
    tabBar.tintColor = .black
    
    viewControllers = [navController]
  }
  
}
