//
//  PostModel.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/7/21.
//

import Foundation

struct Post {
  let user: User
  let mediaUrl: String
  let caption: String
  
  init(user: User, dictionary: [String: Any]) {
    self.user = user
    self.mediaUrl = dictionary["url"] as? String ?? ""
    self.caption = dictionary["caption"] as? String ?? ""
  }
}
