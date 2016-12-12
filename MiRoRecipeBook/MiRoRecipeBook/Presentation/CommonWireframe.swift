//
//  CommonWireframe.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 11.12.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation

class CommonWireframe: NSObject {

    var rootNavigationController: UINavigationController? = nil
    
    init(withRootNavigationController navigationController: UINavigationController?) {
        super.init()
        self.rootNavigationController = navigationController
    }
    
    func popToPreviousController() {
        _ = self.rootNavigationController?.popViewController(animated: true)
    }
    
}
