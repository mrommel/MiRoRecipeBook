//
//  IngredientsTableViewController.swift
//  MiRo.RecipeBook
//
//  Created by Michael Rommel on 22.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import UIKit

class IngredientsTableViewController: UITableViewController {
    
    let recipeManager = RecipeManager()
    var ingredients: [Ingredient]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Ingredients".localized
        
        self.ingredients = recipeManager.allIngredients()
        NSLog("recipes: %d", self.ingredients!.count)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ingredients!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ingredient = self.getIngredient(withIndex: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientsCell", for: indexPath) as! RecipeTableViewCell
        cell.recipeTitleLabel?.text = ingredient.name
        
        let recipes = recipeManager.getRecipes(forIngredient: ingredient.identifier)
        cell.recipeDescriptionLabel?.text = "\(recipes!.count) " + "recipes".localized
        
        let imageUrl = ingredient.getImageUrl()!
        cell.recipeImageView?.setImage(withUrl: imageUrl, placeholder: UIImage(named: "recipe-default-image.png"), crossFadePlaceholder: false, cacheScaled: false)
        
        return cell
    }
    
    func getIngredient(withIndex index: Int) -> Ingredient {
        
        return self.ingredients![index]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredient = self.getIngredient(withIndex: indexPath.row)
        AppDelegate.shared?.appDependecies?.ingredientsWireframe?.presentRecipes(forIngredientIdentifier: ingredient.identifier)
    }
}
