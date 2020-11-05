//
//  LoginViewModel.swift
//  RxCalendar
//
//  Created by Collabera on 11/5/20.
//

import RxSwift

protocol LoginViewModelType {
  var user: PublishSubject<User> { get set }
  var showError: PublishSubject<String> { get set }
  var isCurrentlyHaveUser: Bool { get }
  
  func login(username: String, password: String)
  func register()
  func calendar()
}

class LoginViewModel: LoginViewModelType {
  
  private let userDefault = AppUserDefaultManager.shared
  
  var user = PublishSubject<User>()
  var showError = PublishSubject<String>()
  
  var isCurrentlyHaveUser: Bool {
    return userDefault.getUser() != nil
  }
  
  private let coordinator: SceneCoordinatorType
  init(coordinator: SceneCoordinatorType) {
    self.coordinator = coordinator
  }
  
  func register() {
    let registerViewModel = RegisterViewModel(sceneCoordinator: coordinator)
    coordinator.transition(to: Scene.register(viewModel: registerViewModel), type: .push(animated: true))
  }
  
  func calendar() {
    let calendarViewModel = CalendarViewModel(sceneCoordinator: coordinator)
    coordinator.transition(to: Scene.calendar(viewModel: calendarViewModel), type: .push(animated: true))
  }
  
  func login(username: String, password: String) {
    guard let user = userDefault.getUser() else {
      showError.onNext("No Existing user. Should Register First")
      return
    }
    
    if user.username == username && password == user.password {
      self.user.onNext(user)
    } else {
      showError.onNext("Invalid Credentials")
    }
  }
}
