//
//  AppDelegate.swift
//  AppDelegate
//
//  Created by Marcos Vitureira on 07/09/2021.
//

import Firebase

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    return true
  }
    
}
