//
//  AppDependecies.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 11.12.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation

class AppDependecies: NSObject {
    
    var rootNavigationController: UINavigationController? = nil
    
    // wireframes
    var appWireframe: AppWireframe? = nil
    
    var recipesWireframe: RecipesWireframe? = nil
    var ingredientsWireframe: IngredientsWireframe? = nil
    var categoriesWireframe: CategoriesWireframe? = nil
    var settingsWireframe: SettingsWireframe? = nil
    
    override init() {
        super.init()
    }
    
    convenience init(withWindow window: UIWindow) {
        self.init()
        self.rootNavigationController = UINavigationController.init()
        self.rootNavigationController?.view.backgroundColor = ColorPalette.tintColor
        self.rootNavigationController?.navigationBar.tintColor = ColorPalette.tintColor
        self.rootNavigationController?.navigationBar.barTintColor = ColorPalette.themeColor
        
        self.rootNavigationController?.navigationBar.isHidden = false
        
        self.recipesWireframe = RecipesWireframe.init(withRootNavigationController: self.rootNavigationController)
        self.ingredientsWireframe = IngredientsWireframe.init(withRootNavigationController: self.rootNavigationController)
        self.settingsWireframe = SettingsWireframe.init(withRootNavigationController: self.rootNavigationController)
        self.categoriesWireframe = CategoriesWireframe.init(withRootNavigationController: self.rootNavigationController)
        
        self.appWireframe = AppWireframe.init(withWindow:window, andNavigationController:self.rootNavigationController, appDependencies:self)
        self.appWireframe?.presentRootViewController()
    }
    
}
