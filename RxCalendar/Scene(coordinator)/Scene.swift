//
//  Scene.swift
//  RxCalendar
//
//  Created by Collabera on 11/4/20.
//

import UIKit
import RxSwift

enum Scene {
  case calendar
  case login
  case register
  // Insert Event when need to edit
  case addEvent(event: Event?, date: Date, events: PublishSubject<[Event]>)
}

extension Scene {
  func viewController() -> UIViewController {
    switch self {
    case .login:
      return loginViewController()
    case .register:
      return RegisterViewController()
    case let .addEvent(event, date, events):
      return addEventViewController(event: event, date: date, events: events)
    case .calendar:
      return calendarViewController()
    }
  }
  
  var identifier: String {
    switch self {
    case .login:
      return "LoginViewController"
    case .register:
      return "RegisterViewController"
    case .calendar:
      return "CalendarViewController"
    case .addEvent:
      return "AddEventViewController"
    }
  }
}

extension Scene {
  
  private func loginViewController() -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: identifier)
  }
  
  private func RegisterViewController() -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: identifier)
  }
  
  private func calendarViewController() -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: identifier)
  }
  
  private func addEventViewController(event: Event?, date: Date, events: PublishSubject<[Event]>) -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as! AddEventViewController
    viewController.viewModel = AddEventViewModel(event: event, date: date, events: events)
    return viewController
  }
}
