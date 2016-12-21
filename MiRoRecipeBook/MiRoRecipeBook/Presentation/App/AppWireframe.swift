//
//  AppWireframe.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 12.12.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import Foundation

class AppWireframe: CommonWireframe {
    
    fileprivate let kAppStoryboardName = "App"
    
    var window: UIWindow?
 
    override init(withRootNavigationController navigationController: UINavigationController?) {
        super.init(withRootNavigationController: navigationController)
        
        self.window = nil
    }
    
    convenience init(withWindow window: UIWindow, andNavigationController navigationController: UINavigationController?, appDependencies:AppDependecies) {
        self.init(withRootNavigationController: navigationController)
        
        self.window = window
    }
    
    func presentRootViewController() {
        let revealViewController = SWRevealViewController.instantiate(fromStoryboard: kAppStoryboardName)
        
        self.window?.rootViewController = revealViewController

        self.rootNavigationController?.viewControllers = [revealViewController]
    }
    
}
