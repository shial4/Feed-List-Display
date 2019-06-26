//
//  AppDelegate.swift
//  Feed List Display
//
//  Created by Szymon Lorenz on 26/6/19.
//  Copyright © 2019 Szymon Lorenz. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: ApplicationCoordinator? //Main coordinator referance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /*
         Using coordinator patter we are removing navigation job from the view controllers.
         */
        let coordinator = ApplicationCoordinator(window: window!)
        coordinator.start()
        self.coordinator = coordinator
        return true
    }
}

