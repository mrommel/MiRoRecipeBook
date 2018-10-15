//
//  CommonWireframe.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 11.12.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import UIKit

class CommonWireframe: NSObject {

	var rootNavigationController: UINavigationController? {
		return self.appDelegate.window?.rootViewController as? UINavigationController
	}

	var appDelegate: AppDelegate {
		return (UIApplication.shared.delegate as? AppDelegate)!
	}
    
    func popToPreviousController() {
        _ = self.rootNavigationController?.popViewController(animated: true)
    }
}
