//
//  UserModel.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 5/21/21.
//

import Foundation

struct User {
  let uid: String
  let username: String
  let profileImageUrl: String
  
  init(uid: String, dictionary: [String: Any]) {
    self.uid = uid
    self.username = dictionary["username"] as? String ?? ""
    self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    
  }
}
