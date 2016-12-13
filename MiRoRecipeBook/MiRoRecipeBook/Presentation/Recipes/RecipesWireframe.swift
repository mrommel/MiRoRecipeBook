//
//  RecipesWireframe.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 12.12.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation

class RecipesWireframe: CommonWireframe {

    fileprivate let kRecipesStoryboardName = "Recipes"

    override init(withRootNavigationController navigationController: UINavigationController?) {
        super.init(withRootNavigationController: navigationController)
    }
    
    func getRecipesInterface() -> RecipesTableViewController {
        let recipesTableViewController = RecipesTableViewController.instantiate(fromStoryboard: kRecipesStoryboardName)
        
        return recipesTableViewController
    }
    
    func presentDetail(forRecipe recipe: Recipe?) {
        let recipesDetailViewController = RecipeDetailViewController.instantiate(fromStoryboard: kRecipesStoryboardName)
        recipesDetailViewController.recipe = recipe
        self.rootNavigationController?.pushViewController(recipesDetailViewController, animated: true)
    }

}
