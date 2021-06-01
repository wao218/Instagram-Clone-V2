//
//  UserModel.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 5/21/21.
//

import Foundation

struct User {
  let username: String
  let profileImageUrl: String
  
  init(dictionary: [String: Any]) {
    self.username = dictionary["username"] as? String ?? ""
    self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
  }
}
