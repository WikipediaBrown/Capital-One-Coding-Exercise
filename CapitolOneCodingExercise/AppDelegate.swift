//
//  AppDelegate.swift
//  CapitolOneCodingExercise
//
//  Created by Wikipedia Brown on 4/3/17.
//  Copyright © 2017 Perris Davis. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        TransactionContainer.shared.getAccountData()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = AccountViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

