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

		let menuButton = UIButton(type: .custom)
		menuButton.setImage(UIImage(named: "menu-alt-24.png"), for: .normal)
		menuButton.frame = CGRect(x: 10, y: 0, width: 42, height: 42)
		menuButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
		recipesDetailViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)

		let targetNavigationController = UINavigationController(rootViewController: recipesDetailViewController)

		UIApplication.shared.topMostViewController()?.present(targetNavigationController, animated: true, completion: nil)
    }
}
