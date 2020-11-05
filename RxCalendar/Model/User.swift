//
//  User.swift
//  RxCalendar
//
//  Created by Collabera on 11/5/20.
//

import Foundation

class User: NSObject, NSCoding {
  var username: String
  var password: String
  
  init(username: String, password: String) {
    self.username = username
    self.password = password
  }
  
  required convenience init(coder aDecoder: NSCoder) {
    let username = aDecoder.decodeObject(forKey: "username") as? String ?? ""
    let password = aDecoder.decodeObject(forKey: "password") as? String ?? ""
    
    self.init(username: username, password: password)
  }

  func encode(with aCoder: NSCoder) {
    aCoder.encode(password, forKey: "password")
    aCoder.encode(username, forKey: "username")
  }
}
