//
//  CategoriesWireframe.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 18.12.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import UIKit

class CategoriesWireframe: CommonWireframe {
    
    fileprivate let recipeManager = RecipeManager()
    fileprivate let kCategoriesStoryboardName = "Categories"
    fileprivate let kIngredientsStoryboardName = "Ingredients"
    
    func getCategoriesInterface() -> CategoriesTableViewController {
        let categoriesTableViewController = CategoriesTableViewController.instantiate(fromStoryboard: kCategoriesStoryboardName)
        
        return categoriesTableViewController
    }
 
    func presentRecipes(forCategoryIdentifier categoryIdentifier: Int32) {
        let category = recipeManager.getCategory(withIdentifier: categoryIdentifier)
        
        let recipesListViewController = RecipesListViewController.instantiate(fromStoryboard: kIngredientsStoryboardName)
        recipesListViewController.recipeListTitle = "CategoryRecipes.of".localized + " " + (category?.name)!
        recipesListViewController.recipes = recipeManager.getRecipes(forCategoryIdentifier: categoryIdentifier)
        self.rootNavigationController?.pushViewController(recipesListViewController, animated: true)
    }
}
