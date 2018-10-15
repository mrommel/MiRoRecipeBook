//
//  IngredientsAndStepsTableViewDataSource.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 15.12.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import UIKit

class RecipeDetailTableViewDatasource: NSObject, UITableViewDataSource {
    
    let recipeManager = RecipeManager()
    var recipe: Recipe?
    var steps: [RecipeStep]?
    var ingredients: [RecipeIngredient]?
    var scale: Float = 1.0
    
    init(forRecipe recipe: Recipe?, scale: Float) {
        super.init()
        
        self.recipe = recipe
        self.steps = recipe?.getSteps()
        self.ingredients = recipe?.getRecipeIngredients()
        self.scale = scale
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.ingredients!.count
        } else {
            return self.steps!.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func getRecipeIngredient(withIndex index: Int) -> RecipeIngredient {
        return self.ingredients![index]
    }
    
    func getRecipeStepText(withIndex index: Int) -> String {
        return self.steps![index].text!
    }
    
    func format(_ recipeIngredient: RecipeIngredient?) -> String {
        let amount: Float? = recipeIngredient?.quantity
        let type: String? = recipeIngredient?.type
        let quantity = Quantity.init(withQuantity: amount!, andType: type!)
        return quantity.format(withScale: self.scale)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! RecipeTableViewCell
        
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            let recipeIngredient = self.getRecipeIngredient(withIndex: indexPath.row)
            let ingredient = recipeManager.getIngredient(withIdentifier: recipeIngredient.ingredient_identifier)
            cell.recipeTitleLabel?.text = ingredient?.name
            cell.recipeDescriptionLabel?.text = self.format(recipeIngredient)
            cell.recipeDescriptionLabel?.isHidden = false
            
            if ingredient?.getImageUrl() != nil {
				cell.imageView?.setImage(with: (ingredient?.getImageUrl())!, placeholder: UIImage(named: "recipe-default-image.png"))
            }
        } else {
            let text = self.getRecipeStepText(withIndex: indexPath.row)
            
            cell.recipeTitleLabel?.text = text
            cell.recipeDescriptionLabel?.isHidden = true
            
            cell.imageView?.image = UIImage.init(named: "number\(indexPath.row).png")
            /*if ingredient?.getImageUrl() != nil {
             cell.imageView?.setImage(withUrl: (ingredient?.getImageUrl())!, placeholder: UIImage(named: "recipe-default-image.png"), crossFadePlaceholder: false, cacheScaled: false)
             }*/
        }
        
        return cell
    }
}
