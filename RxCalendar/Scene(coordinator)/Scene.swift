//
//  Scene.swift
//  RxCalendar
//
//  Created by Collabera on 11/4/20.
//

import UIKit
import RxSwift
import RxCocoa

enum Scene {
  case calendar(viewModel: CalendarViewModelType)
  case login(viewModel: LoginViewModelType)
  case register(viewModel: RegisterViewModelType)
  case addEvent(viewModel: AddEventViewModelType)
}

extension Scene {
  func viewController() -> UIViewController {
    switch self {
    case let .login(viewModel):
      return loginViewController(viewModel: viewModel)
    case let .register(viewModel):
      return registerViewController(viewModel: viewModel)
    case let .addEvent(viewModel):
      return addEventViewController(viewModel: viewModel)
    case let .calendar(viewModel):
      return calendarViewController(viewModel: viewModel)
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
  
  private func loginViewController(viewModel: LoginViewModelType) -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as! LoginViewController
    viewController.viewModel = viewModel
    let navigationController = UINavigationController(rootViewController: viewController)
    return navigationController
  }
  
  private func registerViewController(viewModel: RegisterViewModelType) -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as! RegisterViewController
    viewController.viewModel = viewModel
    return viewController
  }
  
  private func calendarViewController(viewModel: CalendarViewModelType) -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as! CalendarViewController
    viewController.viewModel = viewModel
    return viewController
  }
  
  private func addEventViewController(viewModel: AddEventViewModelType) -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as! AddEventViewController
    viewController.viewModel = viewModel
    return viewController
  }
}
