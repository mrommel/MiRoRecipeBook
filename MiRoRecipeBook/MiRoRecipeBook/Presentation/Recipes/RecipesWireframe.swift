//
//  RecipesWireframe.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 12.12.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import UIKit

class RecipesWireframe: CommonWireframe {

    fileprivate let kRecipesStoryboardName = "Recipes"
    
    func getRecipesInterface() -> RecipeCollectionViewController {
        //let recipesTableViewController = RecipesTableViewController.instantiate(fromStoryboard: kRecipesStoryboardName)
        let recipesTableViewController = RecipeCollectionViewController.instantiate(fromStoryboard: kRecipesStoryboardName)
        
        return recipesTableViewController
    }
    
    func presentDetail(forRecipe recipe: Recipe?) {
        let recipesDetailViewController = RecipeDetailViewController.instantiate(fromStoryboard: kRecipesStoryboardName)
        recipesDetailViewController.recipe = recipe
        self.rootNavigationController?.pushViewController(recipesDetailViewController, animated: true)
    }

}
