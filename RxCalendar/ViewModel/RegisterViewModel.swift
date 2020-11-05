//
//  RegisterViewModel.swift
//  RxCalendar
//
//  Created by Collabera on 11/5/20.
//

import RxSwift

protocol RegisterViewModelType {
  var registered: PublishSubject<Void> { get set }
  
  func register(username: String, password: String)
  func pop()
}

class RegisterViewModel: RegisterViewModelType {
  
  var registered = PublishSubject<Void>()
  
  private let userDefaults = AppUserDefaultManager.shared
  
  private let sceneCoordinator: SceneCoordinatorType
  init(sceneCoordinator: SceneCoordinatorType) {
    self.sceneCoordinator = sceneCoordinator
  }
  
  func pop() {
    sceneCoordinator.pop(animated: true)
  }
  
  func register(username: String, password: String) {
    let user = User(username: username, password: password)
    userDefaults.saveUser(user: user)
    
    sceneCoordinator.pop(animated: true)
  }
}
