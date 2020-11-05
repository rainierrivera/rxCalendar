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
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    let navigationViewController = UINavigationController(rootViewController: Scene.login.viewController())
    window.rootViewController = navigationViewController
    window.makeKeyAndVisible()
    return true
  }

}

