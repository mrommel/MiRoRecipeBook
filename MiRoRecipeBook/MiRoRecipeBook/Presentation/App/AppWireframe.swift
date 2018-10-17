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

		if SideMenuManager.default.menuLeftNavigationController == nil {
			// Define the menus
			let menuViewController = MenuTableViewController.instantiate(fromStoryboard: kAppStoryboardName)
			menuViewController.appWireframe = self
			let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: menuViewController)

			// UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
			// of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
			SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController

			// (Optional) Prevent status bar area from turning black when menu appears:
			SideMenuManager.default.menuFadeStatusBar = false

			// set menu width to 300px
			SideMenuManager.default.menuWidth = 300
		}
    }

	func showHintScreen() {

		let hintViewController = HintViewController.instantiate(fromStoryboard: kAppStoryboardName)
		hintViewController.appWireframe = self
		self.rootNavigationController?.present(hintViewController, animated: false, completion: nil)

		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
			self.showMenu()
		})
	}

	func showDetail(for viewController: UIViewController?) {

		let menuButton = UIButton(type: .custom)
		menuButton.setImage(UIImage(named: "menu-alt-24.png"), for: .normal)
		menuButton.frame = CGRect(x: 10, y: 0, width: 42, height: 42)
		menuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
		viewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)

		let targetNavigationController = UINavigationController(rootViewController: viewController!)

		self.hideMenu(completion: {
			if let hintViewController = self.rootNavigationController?.presentedViewController as? HintViewController {
				hintViewController.present(targetNavigationController, animated: false, completion: nil)
			}
		})
	}

	@objc func openMenu(_ sender: AnyObject) {
		self.showMenu()
	}

	func showMenu(completion: (() -> Void)? = nil) {

		if let viewController = UIApplication.shared.topMostViewController() {
			if let menuLeftNavigationController = SideMenuManager.default.menuLeftNavigationController {
				viewController.present(menuLeftNavigationController, animated: true, completion: completion)
			}
		}
	}

	func hideMenu(completion: (() -> Void)? = nil) {

		if let hintViewController = self.rootNavigationController?.presentedViewController as? HintViewController {
			hintViewController.dismiss(animated: true, completion: completion)
		}
	}
}
