//
//  AppUserDefault.swift
//  RxCalendar
//
//  Created by Collabera on 11/2/20.
//

import Foundation

class AppUserDefaultManager {
  static let shared = AppUserDefaultManager()
  
  private let userDefaults: UserDefaults = .standard
  
  // In real world app, should save password to keychain
  func saveUser(user: User) {
    do {
      let data: Data = try NSKeyedArchiver.archivedData(withRootObject: user,
                                                    requiringSecureCoding: false)
      userDefaults.set(data, forKey: "user") // Since we are going to use 1 user for this app
      userDefaults.synchronize()
    } catch {
      fatalError("Unable to save User")
    }
  }
  
  func getUser() -> User? {
    guard let data = userDefaults.data(forKey: "user") else {
      return nil
    }
    
    do {
      return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? User
    } catch {
      fatalError("loadWidgetDataArray - Can't encode data: \(error)")
    }
  }
  
  
  func saveEvent(_ event: Event) {
    var events = getAllEvents()

    events.append(event)
    
    do {
      let data: Data = try NSKeyedArchiver.archivedData(withRootObject: events,
                                                        requiringSecureCoding: false)
      userDefaults.set(data, forKey: "events")
      userDefaults.synchronize()
    } catch {
      fatalError("Unable to save todos \(error.localizedDescription)")
    }
  }
  
  func getAllEvents() -> [Event] {
    guard let data = userDefaults.data(forKey: "events") else {
      return []
    }
    do {
      return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Event] ?? []
    } catch {
      fatalError("Can't encode data: \(error)")
    }
  }
  
  func editEvent(_ event: Event) {
    
  }
  
  func delete(_ event: Event) {
    let events = getAllEvents()
    let filteredEvents = events.filter { $0.id != event.id}
    
    do {
      let data: Data = try NSKeyedArchiver.archivedData(withRootObject: filteredEvents,
                                                    requiringSecureCoding: false)
      userDefaults.set(data, forKey: "events")
      userDefaults.synchronize()
    } catch {
      fatalError("unable to delete event")
    }
  }
}
