//
//  SettingsWireFrame.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 11.12.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import UIKit

class SettingsWireframe: CommonWireframe {
    
    fileprivate let kSettingsStoryboardName = "Settings"
    
    func getSettingsInterface() -> SettingsTableViewController {
        let settingsTableViewController = SettingsTableViewController.instantiate(fromStoryboard: kSettingsStoryboardName)
        
        return settingsTableViewController
    }
}
