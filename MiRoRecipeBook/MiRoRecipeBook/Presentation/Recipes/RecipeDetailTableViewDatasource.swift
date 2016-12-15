//
//  IngredientsAndStepsTableViewDataSource.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 15.12.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation

class RecipeDetailTableViewDatasource: NSObject, UITableViewDataSource {
    
    let recipeManager = RecipeManager()
    var recipe: Recipe?
    var steps: [RecipeStep]?
    var ingredients: [RecipeIngredient]?
    
    init(forRecipe recipe: Recipe?) {
        super.init()
        
        self.recipe = recipe
        self.steps = recipe?.getSteps()
        self.ingredients = recipe?.getRecipeIngredients()
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
    
    func getRecipeStep(withIndex index: Int) -> String {
        return self.steps![index].step!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! RecipeTableViewCell
        
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            let recipeIngredient = self.getRecipeIngredient(withIndex: indexPath.row)
            let ingredient = recipeManager.getIngredient(withIdentifier: recipeIngredient.ingredient_identifier)
            cell.recipeTitleLabel?.text = ingredient?.name
            cell.recipeDescriptionLabel?.text = recipeIngredient.quantity
            
            if ingredient?.getImageUrl() != nil {
                cell.imageView?.setImage(withUrl: (ingredient?.getImageUrl())!, placeholder: UIImage(named: "recipe-default-image.png"), crossFadePlaceholder: false, cacheScaled: false)
            }
        } else {
            let step = self.getRecipeStep(withIndex: indexPath.row)
            
            cell.recipeTitleLabel?.text = step
            cell.recipeDescriptionLabel?.text = ""
            
            cell.imageView?.image = UIImage.init(named: "number\(indexPath.row).png")
            /*if ingredient?.getImageUrl() != nil {
             cell.imageView?.setImage(withUrl: (ingredient?.getImageUrl())!, placeholder: UIImage(named: "recipe-default-image.png"), crossFadePlaceholder: false, cacheScaled: false)
             }*/
        }
        
        return cell
    }
}
