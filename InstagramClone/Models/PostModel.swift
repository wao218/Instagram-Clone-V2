//
//  PostModel.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/7/21.
//

import Foundation

struct Post {
  let mediaUrl: String
  
  init(dictionary: [String: Any]) {
    self.mediaUrl = dictionary["url"] as? String ?? ""
  }
}
