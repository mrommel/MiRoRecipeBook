//
//  AppDependecies.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 11.12.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import UIKit

class AppDependecies: NSObject {
    
    var rootNavigationController: UINavigationController? = nil
    
    // wireframes
    var appWireframe: AppWireframe? = nil
    
    var recipesWireframe: RecipesWireframe? = nil
    var ingredientsWireframe: IngredientsWireframe? = nil
    var categoriesWireframe: CategoriesWireframe? = nil
    var settingsWireframe: SettingsWireframe? = nil
    
    convenience init(with window: UIWindow) {
        self.init()

		self.appWireframe = AppWireframe.init(withWindow: window)

		self.rootNavigationController = self.appWireframe?.rootNavigationController
        self.rootNavigationController?.view.backgroundColor = ColorPalette.tintColor
        self.rootNavigationController?.navigationBar.tintColor = ColorPalette.tintColor
        self.rootNavigationController?.navigationBar.barTintColor = ColorPalette.themeColor
        self.rootNavigationController?.navigationBar.isHidden = false
        
        self.recipesWireframe = RecipesWireframe()
        self.ingredientsWireframe = IngredientsWireframe()
        self.settingsWireframe = SettingsWireframe()
        self.categoriesWireframe = CategoriesWireframe()
    }
    
}
