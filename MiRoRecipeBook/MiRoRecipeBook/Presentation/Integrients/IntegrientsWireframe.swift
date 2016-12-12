//
//  IntegrientsWireframe.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 12.12.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation

class IntegrientsWireframe: CommonWireframe {
    
    fileprivate let kIntegrientsStoryboardName = "Integrients"
    
    override init(withRootNavigationController navigationController: UINavigationController?) {
        super.init(withRootNavigationController: navigationController)
    }
    
    func getIntegrientsInterface() -> IntegrientsTableViewController {
        let integrientsTableViewController = IntegrientsTableViewController.instantiate(fromStoryboard: kIntegrientsStoryboardName)
        
        return integrientsTableViewController
    }
    
}
