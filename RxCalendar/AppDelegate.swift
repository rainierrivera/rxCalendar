//
//  AppDelegate.swift
//  RxCalendar
//
//  Created by Collabera on 10/30/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    
    window?.rootViewController = UIViewController()
    let sceneCoordinator = SceneCoordinator(window: window!)
    
    let scene = Scene.login(viewModel: LoginViewModel(coordinator: sceneCoordinator))
    sceneCoordinator.transition(to: scene, type: .root)
    return true
  }

}

