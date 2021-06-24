//
//  CommentModel.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/24/21.
//

import Foundation

struct Comment {
  let text: String
  let uid: String
  
  init(dictionary: [String: Any]) {
    self.text = dictionary["text"] as? String ?? ""
    self.uid = dictionary["uid"] as? String ?? ""
  }
}
