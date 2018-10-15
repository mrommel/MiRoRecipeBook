//
//  AppWireframe.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 12.12.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import UIKit
import SideMenu

class AppWireframe: CommonWireframe {
    
    fileprivate let kAppStoryboardName = "App"
    
    var window: UIWindow?

    init(withWindow window: UIWindow) {

		self.window = window

        super.init()
    }

	func showHintScreen() {

		let hintViewController = HintViewController.instantiate(fromStoryboard: kAppStoryboardName)
		hintViewController.appWireframe = self
		self.rootNavigationController?.present(hintViewController, animated: true, completion: nil)
	}

	func showDetail(navigationController: UINavigationController?) {

		if let hintViewController = self.rootNavigationController?.presentedViewController as? HintViewController {
			hintViewController.dismiss(animated: true, completion: {
				hintViewController.show(navigationController!, sender: nil)
			})
		}
	}

	func showMenu() {

		if SideMenuManager.default.menuLeftNavigationController == nil {
			// Define the menus
			let menuViewController = MenuTableViewController.instantiate(fromStoryboard: kAppStoryboardName)
			menuViewController.appWireframe = self
			let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: menuViewController)

			// UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
			// of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
			SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController

			// (Optional) Enable gestures. The left and/or right menus must be set up above for these to work.
			// Note that these continue to work on the Navigation Controller independent of the view controller it displays!
			//SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
			//SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)

			// (Optional) Prevent status bar area from turning black when menu appears:
			SideMenuManager.default.menuFadeStatusBar = false
		}

		//if let hintViewController = self.rootNavigationController?.presentedViewController as? HintViewController {
		if let viewController = UIApplication.shared.topMostViewController() {
			viewController.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
		}
	}

	func hideMenu() {
		if let hintViewController = self.rootNavigationController?.presentedViewController as? HintViewController {
			hintViewController.dismiss(animated: true, completion: nil)
		}
	}
    
}
