//
//  AppDelegate.swift
//  BreakingNews
//
//  Created by Julian Astrada on 06/07/2020.
//  Copyright © 2020 Julian Astrada. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = TopHeadlinesViewController.newInstance()
        window?.makeKeyAndVisible()
        
        return false
    }

}

