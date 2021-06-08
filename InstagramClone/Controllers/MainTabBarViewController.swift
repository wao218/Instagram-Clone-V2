//
//  MainTabBarViewController.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 5/20/21.
//

import UIKit
import Firebase

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
  
  // MARK: LIFECYCLE METHODS
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.delegate = self
    
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
  
  // MARK: - UITabBarController Delegate
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    let index = viewControllers?.firstIndex(of: viewController)
    if index == 2 {
      let layout = UICollectionViewFlowLayout()
      let mediaSelectorController = MediaSelectorCollectionViewController(collectionViewLayout: layout)
      let navController = UINavigationController(rootViewController: mediaSelectorController)
      navController.modalPresentationStyle = .fullScreen
      present(navController, animated: true, completion: nil)
      return false
    }
    return true
  }
  
  
  // MARK: - HELPER METHODS
  func setupViewControllers() {
    // Home Tab
    let homeNavController = templateNavController(unselectedImage: UIImage(named: "home_unselected"), selectedImage: UIImage(named: "home_selected"), rootViewController: HomeCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()))
    
    // search Tab
    
    let searchNavController = templateNavController(unselectedImage: UIImage(named: "search_unselected"), selectedImage: UIImage(named: "search_selected"))
    
    // Add photo / video tab
    let plusNavController = templateNavController(unselectedImage: UIImage(named: "plus_unselected"), selectedImage: UIImage(named: "plus_unselected"))
    
    // Activity tab
    let activityNavController = templateNavController(unselectedImage: UIImage(named: "like_unselected"), selectedImage: UIImage(named: "like_selected"))
    
    // User Profile Tab
    let layout = UICollectionViewFlowLayout()
    let userProfileVC = UserProfileViewController(collectionViewLayout: layout)
    
    let userProfileNavController = UINavigationController(rootViewController: userProfileVC)
    
    userProfileNavController.tabBarItem.image = UIImage(named: "profile_unselected")
    userProfileNavController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
    
    tabBar.tintColor = .black
    
    viewControllers = [homeNavController,
                       searchNavController,
                       plusNavController,
                       activityNavController,
                       userProfileNavController]
    
    // Modify tab bar item insets
    guard let items = tabBar.items else { return }
    for item in items {
      item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
    }
  }
  
  private func templateNavController(unselectedImage: UIImage?, selectedImage: UIImage?, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
    let viewController = rootViewController
    let navController = UINavigationController(rootViewController: viewController)
    navController.tabBarItem.image = unselectedImage
    navController.tabBarItem.selectedImage = selectedImage
    return navController
  }
  
}
