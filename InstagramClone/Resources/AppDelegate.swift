//
//  AppDelegate.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 5/18/21.
//

import UIKit
import CoreData
import Firebase
import UserNotifications
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {



  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    FirebaseApp.configure()
    
    attemptToRegisterForNotifications(application: application)
    
    return true
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("Registerd for notifications:", deviceToken)
  }
  
  // MARK: - MessagingDelegate
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Registered with FCM with token:", fcmToken ?? "")
  }
  
  // MARK: - UserNotificationCenterDelegate
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler(.banner)
  }
  
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    
    if let followerId = userInfo["followerId"] as? String {
      print("This is the follwer id: ", followerId)
      
      let userProfileController = UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
      
      userProfileController.userId = followerId
      
      let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
      
      if let mainTabBarController = sceneDelegate.window?.rootViewController as? MainTabBarViewController {
        
        mainTabBarController.selectedIndex = 0
        mainTabBarController.presentedViewController?.dismiss(animated: true, completion: nil)
        
        if let homeNavigationController = mainTabBarController.viewControllers?.first as? UINavigationController {
         
          homeNavigationController.pushViewController(userProfileController, animated: true)
        }
      }
    }
  }

  
 
  
  // MARK: - Helper Methods
  
  private func attemptToRegisterForNotifications(application: UIApplication) {
    print("attempting to register APNS...")
    
    UNUserNotificationCenter.current().delegate = self
    Messaging.messaging().delegate = self
    // user notifications auth
    // all of this works for iOS 10+
    let options: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
      guard error == nil else {
        print("failed to request auth:", error ?? "")
        return
      }
      
      if granted {
        print("auth granted")
      } else {
        print("auth denied")
      }
    }
    
    application.registerForRemoteNotifications()
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }

  // MARK: - Core Data stack

  lazy var persistentContainer: NSPersistentContainer = {
      /*
       The persistent container for the application. This implementation
       creates and returns a container, having loaded the store for the
       application to it. This property is optional since there are legitimate
       error conditions that could cause the creation of the store to fail.
      */
      let container = NSPersistentContainer(name: "InstagramClone")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error as NSError? {
              // Replace this implementation with code to handle the error appropriately.
              // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
               
              /*
               Typical reasons for an error here include:
               * The parent directory does not exist, cannot be created, or disallows writing.
               * The persistent store is not accessible, due to permissions or data protection when the device is locked.
               * The device is out of space.
               * The store could not be migrated to the current model version.
               Check the error message to determine what the actual problem was.
               */
              fatalError("Unresolved error \(error), \(error.userInfo)")
          }
      })
      return container
  }()

  // MARK: - Core Data Saving support

  func saveContext () {
      let context = persistentContainer.viewContext
      if context.hasChanges {
          do {
              try context.save()
          } catch {
              // Replace this implementation with code to handle the error appropriately.
              // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
              let nserror = error as NSError
              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
      }
  }

}

