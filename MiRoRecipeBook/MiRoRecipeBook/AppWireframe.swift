//
//  AppWireframe.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 12.12.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation

class AppWireframe: CommonWireframe {
    
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
        let storyboard = UIStoryboard(name: "App", bundle: nil)
        
        let revealViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        
        self.window?.rootViewController = revealViewController

        self.rootNavigationController?.viewControllers = [revealViewController]
    }
    
}
