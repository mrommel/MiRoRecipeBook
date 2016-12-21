//
//  AppDelegate.swift
//  com.bosch.ebike.mobile-app
//
//  Created by Michael Rommel on 22.11.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var shared: AppDelegate? = nil
    var window: UIWindow?
    var appDependecies: AppDependecies?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        AppDelegate.shared = self
        self.appDependecies = AppDependecies.init(withWindow: self.window!)
        configureAppStyling()
        
        // init core data
        CoreDataManager.sharedInstance()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

}

extension AppDelegate {
    
}

private extension AppDelegate {
    
    func configureAppStyling() {
        styleNavigationBar()
        styleBarButtons()
    }

    func styleNavigationBar() {
        UINavigationBar.appearance().barTintColor = ColorPalette.themeColor
        UINavigationBar.appearance().tintColor = ColorPalette.tintColor
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName : FontPalette.navBarTitleFont(),
            NSForegroundColorAttributeName : ColorPalette.navigationBarTitleColor
        ]
    }
    
    func styleBarButtons() {
        let barButtonTextAttributes = [
            NSFontAttributeName : FontPalette.navBarButtonFont(),
            NSForegroundColorAttributeName : ColorPalette.tintColor
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonTextAttributes, for: .normal)
    }
}
