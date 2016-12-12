//
//  SettingsWireFrame.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 11.12.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation

class SettingsWireframe: CommonWireframe {
    
    fileprivate let kSettingsStoryboardName = "Settings"
    
    override init(withRootNavigationController navigationController: UINavigationController?) {
        super.init(withRootNavigationController: navigationController)
    }
    
    func getSettingsInterface() -> SettingsTableViewController {
        let settingsTableViewController = SettingsTableViewController.instantiate(fromStoryboard: kSettingsStoryboardName)
        
        return settingsTableViewController
    }
}
