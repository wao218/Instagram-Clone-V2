//
//  MainTabBarViewController.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 5/20/21.
//

import UIKit

class MainTabBarViewController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let layout = UICollectionViewFlowLayout()
    let userProfileVC = UserProfileViewController(collectionViewLayout: layout)
    
    let navController = UINavigationController(rootViewController: userProfileVC)
    
    navController.tabBarItem.image = UIImage(named: "profile_unselected")
    navController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
    
    tabBar.tintColor = .black
    
    viewControllers = [navController]
    
  }
  
  
}
