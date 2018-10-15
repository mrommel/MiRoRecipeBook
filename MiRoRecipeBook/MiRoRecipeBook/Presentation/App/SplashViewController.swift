//
//  SplashViewController.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 15.10.18.
//  Copyright © 2018 MiRo Soft. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

	var appWireframe: AppWireframe?

	override func viewDidLoad() {
		super.viewDidLoad()

		self.title = "Splash"
		self.appWireframe = AppDelegate.shared?.appDependecies?.appWireframe
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		self.appWireframe?.showHintScreen()
	}
}
