//
//  FirebaseExtensions.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/11/21.
//

import Foundation
import Firebase

extension Firebase.Database {
  static func fetchUserWithUID(uid: String, completion: @escaping (User) -> Void) {
    Firebase.Database.database().reference().child("users/\(uid)").observeSingleEvent(of: .value) { snapshot in
      guard let userDictionary = snapshot.value as? [String: Any] else { return }
      let user = User(uid: uid, dictionary: userDictionary)
      
      completion(user)
      
    } withCancel: { error in
      print("Failed to fetch user: \(error)")
    }
  }
}
