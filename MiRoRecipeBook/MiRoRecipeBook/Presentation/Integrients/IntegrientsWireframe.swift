//
//  IngredientsWireframe.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 12.12.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import UIKit

class IngredientsWireframe: CommonWireframe {
    
    fileprivate let recipeManager = RecipeManager()
    fileprivate let kIngredientsStoryboardName = "Ingredients"
    
    func getIngredientsInterface() -> IngredientsTableViewController {
        let ingredientsTableViewController = IngredientsTableViewController.instantiate(fromStoryboard: kIngredientsStoryboardName)
        
        return ingredientsTableViewController
    }
 
    func presentRecipes(forIngredientIdentifier ingredientIdentifier: Int32) {
        let ingredient = recipeManager.getIngredient(withIdentifier: ingredientIdentifier)
        
        let recipesListViewController = RecipesListViewController.instantiate(fromStoryboard: kIngredientsStoryboardName)
        recipesListViewController.recipeListTitle = "IngredientRecipes.of".localized + " " + (ingredient?.name)!
        recipesListViewController.recipes = recipeManager.getRecipes(forIngredient: ingredientIdentifier)

		recipesListViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< " + "Ingredients".localized, style: .plain, target: self, action: #selector(goBack))

		let targetNavigationController = UINavigationController(rootViewController: recipesListViewController)

		UIApplication.shared.topMostViewController()?.present(targetNavigationController, animated: true, completion: nil)
    }
}
