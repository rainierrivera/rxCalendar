//
//  SceneCoordinator.swift
//  RxCalendar
//
//  Created by Collabera on 11/5/20.
//

import UIKit
import RxSwift

enum SceneTransitionType {
    case root
    case push(animated: Bool)
    case modal(animated: Bool)
}

protocol SceneCoordinatorType {
    init(window: UIWindow)
    
    var currentViewController: UIViewController { get }
    
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable
    
    // pop scene from navigation stack or dismiss current modal
    @discardableResult
    func pop(animated: Bool) -> Completable
    
    @discardableResult
    func popToRoot(animated: Bool) -> Completable
    
    @discardableResult
    func popToVC(_ viewController: UIViewController, animated: Bool) -> Completable
}

final class SceneCoordinator: SceneCoordinatorType {
    
  fileprivate var window: UIWindow
  var currentViewController: UIViewController
  
  required init(window: UIWindow) {
    self.window = window
    currentViewController = window.rootViewController!
  }
  
  static func actualViewController(for viewController: UIViewController) -> UIViewController {
    if let navigationController = viewController as? UINavigationController {
      return navigationController.viewControllers.first!
    } else {
      return viewController
    }
  }
  
  @discardableResult
  func transition(to scene: Scene, type: SceneTransitionType) -> Completable {
      let subject = PublishSubject<Void>()
      let viewController = scene.viewController()
      switch type {
      case .root:
          currentViewController = SceneCoordinator.actualViewController(for: viewController)
          window.rootViewController = viewController
          subject.onCompleted()
          
      case .push(let animated):
          guard let navigationController = currentViewController.navigationController else {
              fatalError("Can't push a view controller without a current navigation controller")
          }
          // one-off subscription to be notified when push complete
          _ = navigationController.rx.delegate
              .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
              .map { _ in }
              .bind(to: subject)
          navigationController.pushViewController(viewController, animated: animated)
          currentViewController = SceneCoordinator.actualViewController(for: viewController)
          
      case .modal(let animated):
          currentViewController.present(viewController, animated: animated) {
              subject.onCompleted()
          }
          currentViewController = SceneCoordinator.actualViewController(for: viewController)
      }
      return subject.asObservable()
          .take(1)
          .ignoreElements()
  }
  
  @discardableResult
  func pop(animated: Bool) -> Completable {
      let subject = PublishSubject<Void>()
      if let presenter = currentViewController.presentingViewController {
          // dismiss a modal controller
          currentViewController.dismiss(animated: animated) {
              self.currentViewController = SceneCoordinator.actualViewController(for: presenter)
              subject.onCompleted()
          }
      } else if let navigationController = currentViewController.navigationController {
          // navigate up the stack
          // one-off subscription to be notified when pop complete
          _ = navigationController.rx.delegate
              .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
              .take(1) // To delete if already in return at bottom
              .map { _ in }
              .bind(to: subject)
          
          guard navigationController.popViewController(animated: animated) != nil else {
              fatalError("can't navigate back from \(currentViewController)")
          }
          currentViewController = SceneCoordinator.actualViewController(for: navigationController.viewControllers.last!)
      } else {
          fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController)")
      }
      return subject.asObservable()
          .take(1)
          .ignoreElements()
  }
  
  @discardableResult
  func popToRoot(animated: Bool) -> Completable {
      
      let subject = PublishSubject<Void>()
      
      if let navigationController = currentViewController.navigationController {
          // navigate up the stack
          // one-off subscription to be notified when pop complete
          _ = navigationController.rx.delegate
              .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
              .take(1) // To delete if already in return at bottom
              .map { _ in }
              .bind(to: subject)
          
          guard navigationController.popToRootViewController(animated: animated) != nil else {
              fatalError("can't navigate back to root VC from \(currentViewController)")
          }
          currentViewController = SceneCoordinator.actualViewController(for: navigationController.viewControllers.first!)
      }
      
      return subject.asObservable()
          .take(1)
          .ignoreElements()
  }
  
  @discardableResult
  func popToVC(_ viewController: UIViewController, animated: Bool) -> Completable {
      
      let subject = PublishSubject<Void>()
      
      if let navigationController = currentViewController.navigationController {
          // navigate up the stack
          // one-off subscription to be notified when pop complete
          _ = navigationController.rx.delegate
              .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
              .take(1) // To delete if already in return at bottom
              .map { _ in }
              .bind(to: subject)
          
          guard navigationController.popToViewController(viewController, animated: animated) != nil else {
              fatalError("can't navigate back to VC from \(currentViewController)")
          }
          currentViewController = SceneCoordinator.actualViewController(for: navigationController.viewControllers.last!)
      }
      return subject.asObservable()
          .take(1)
          .ignoreElements()
  }
}
