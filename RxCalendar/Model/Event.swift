//
//  File.swift
//  RxCalendar
//
//  Created by Collabera on 10/30/20.
//

import Foundation

class Event: NSObject, NSCoding  {
  let name: String
  let date: Date
  let dateEnd: Date
  var id: String
  
  init(name: String, date: Date, dateEnd: Date, id: String) {
    self.name = name
    self.date = date
    self.dateEnd = dateEnd
    self.id = id
  }
  
  required convenience init(coder aDecoder: NSCoder) {
    let name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
    let id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
    let date = aDecoder.decodeObject(forKey: "date") as? Date ?? Date()
    let dateEnd = aDecoder.decodeObject(forKey: "dateEnd") as? Date ?? Date()
    self.init(name:name, date: date, dateEnd: dateEnd, id: id)
  }

  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: "name")
    aCoder.encode(id, forKey: "id")
    aCoder.encode(date, forKey: "date")
    aCoder.encode(dateEnd, forKey: "dateEnd")
  }
}

