//
//  RecipeManager.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 27.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import CoreData
import Foundation
import SwiftyJSON

protocol RecipesProtocol: class {
    
    func importRecipes()
    func getRecipe(withIdentifier indentifier: Int32) -> Recipe?
    func allRecipes() -> [Recipe]?
}

protocol RecipeStepsProtocol: class {
    
    func storeRecipe(withIdentifier identifier: Int32) -> Recipe?
    func getRecipeSteps(withRecipeIdentifier identifier: Int32) -> [RecipeStep]?
}

protocol RecipeIngredientsProtocol: class {
    
    func storeRecipeIngredient(withRecipeIdentifier identifier: Int32, ingredientIdentifier: Int32, ingredientQuantity: String)
    func getRecipeIngredients(withRecipeIdentifier identifier: Int32) -> [RecipeIngredient]?
}

protocol IngredientsProtocol: class {
    
    func importIngredients()
    func getIngredient(withIdentifier indentifier: Int32) -> Ingredient?
    func allIngredients() -> [Ingredient]?
    func getRecipes(forIngredient ingredient: Int32) -> [Recipe]?
}

class RecipeManager: NSObject {
    
    fileprivate var webservice: RecipeWebService?
}

extension RecipeManager: RecipesProtocol {
    
    func importRecipes() {
        
        let webservice = RecipeWebService()
        webservice.getAllRecipeJSONs(onCompletion: { recipeJSONs in
            
            for recipeJSON in recipeJSONs! as [JSON] {
                let identifier = recipeJSON["id"].int32Value
                NSLog("got recipe from web service: %d => %@", identifier, recipeJSON["name"].stringValue)
                
                // try to fetch from internal storage
                var recipe = self.getRecipe(withIdentifier: identifier)
                
                // create recipe if needed
                if recipe == nil {
                    recipe = self.storeRecipe(withIdentifier: identifier)
                    
                    // update or set values from dict
                    recipe?.name = recipeJSON["name"].stringValue
                    recipe?.desc = recipeJSON["description"].stringValue
                    recipe?.teaser = recipeJSON["teaser"].stringValue
                    recipe?.image_url = recipeJSON["image_url"].stringValue
                    recipe?.calories = recipeJSON["calories"].int32Value
                    recipe?.time = recipeJSON["time"].int32Value
                    recipe?.portions = recipeJSON["portions"].int32Value
                    
                    CoreDataManager.sharedInstance().save(recipe)
                    
                    for stepJSON in recipeJSON["steps"].array! as [JSON] {
                        let step = stepJSON.stringValue
                        //NSLog("step %d => %@", identifier, step)
                        let _ = self.storeRecipeStep(withIdentifier: identifier, step: step)
                    }
                    
                    for ingredientJSON in recipeJSON["integrients"].array! as [JSON] {
                        let ingredientIdentifier = ingredientJSON["id"].int32Value
                        let ingredientQuantity = ingredientJSON["quantity"].stringValue

                        self.storeRecipeIngredient(withRecipeIdentifier: identifier, ingredientIdentifier: ingredientIdentifier, ingredientQuantity: ingredientQuantity)
                    }
                    
                    NSLog("recipe created: %@", recipeJSON["name"].stringValue)
                } else {
                    NSLog("recipe already exists: %@", recipe ?? "<default>")
                }
            }
        })
    }
    
    func getRecipe(withIdentifier indentifier: Int32) -> Recipe? {
        
        let context = CoreDataManager.sharedInstance().mainContext!
        
        // try to get a recipe ...
        let fetchRequest = NSFetchRequest<Recipe>(entityName: "Recipe")
        
        // ... with identifier
        fetchRequest.predicate = NSPredicate.init(format: "identifier == %d", indentifier)
        
        do {
            //go get the results
            let searchResults = try context.fetch(fetchRequest)
            
            if searchResults.count == 1 {
                return searchResults[0]
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        
        return nil
    }
    
    func storeRecipe(withIdentifier identifier: Int32) -> Recipe? {
        
        //let context = CoreDataManager.sharedInstance().mainContext!
        
        // retrieve the Recipe
        let recipe = CoreDataManager.sharedInstance().createNSManagedObject(forClassName: Recipe.nameOfClass)
        
        // set the entity values
        recipe?.setValue(NSNumber.init(value: identifier), forKey: "identifier")
        
        // save the object
        CoreDataManager.sharedInstance().save(recipe)
        print("recipe \(recipe) saved!")
        return recipe as? Recipe
    }
    
    func allRecipes() -> [Recipe]? {
        
        let context = CoreDataManager.sharedInstance().mainContext!
        
        let fetchRequest = NSFetchRequest<Recipe>(entityName: "Recipe")
        
        // ... with identifier
        fetchRequest.predicate = NSPredicate.init(value: true)
        
        do {
            // go get the results
            let searchResults = try context.fetch(fetchRequest)
            
            // I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")
            
            var recipes: [Recipe]? = []
            
            // You need to convert to NSManagedObject to use 'for' loops
            for recipe in searchResults {
                //get the Key Value pairs (although there may be a better way to do that...
                //print("\(recipe.name)")
                recipes?.append(recipe)
            }
            
            return recipes
        } catch {
            print("Error with request: \(error)")
        }
        
        return nil
    }
}

extension RecipeManager: RecipeStepsProtocol {
    
    func storeRecipeStep(withIdentifier identifier: Int32, step: String) -> RecipeStep? {
        
        let context = CoreDataManager.sharedInstance().mainContext!
        
        // retrieve the RecipeStep
        let entity =  NSEntityDescription.entity(forEntityName: "RecipeStep", in: context)
        
        let recipeStep = NSManagedObject(entity: entity!, insertInto: context)
        
        // set the entity values
        recipeStep.setValue(NSNumber.init(value: identifier), forKey: "recipe_identifier")
        recipeStep.setValue(step, forKey: "step")
        
        // save the object
        CoreDataManager.sharedInstance().save(recipeStep)
        print("recipeStep saved!")
        return recipeStep as? RecipeStep
    }
    
    func getRecipeSteps(withRecipeIdentifier identifier: Int32) -> [RecipeStep]? {
        
        let context = CoreDataManager.sharedInstance().mainContext!
        
        // try to get a recipe ...
        let fetchRequest = NSFetchRequest<RecipeStep>(entityName: "RecipeStep")
        
        // ... with identifier
        fetchRequest.predicate = NSPredicate.init(format: "recipe_identifier == %d", identifier)
        
        do {
            //go get the results
            let searchResults = try context.fetch(fetchRequest)
            
            return searchResults
            
        } catch {
            print("Error with request: \(error)")
        }
        
        return nil
    }
}

extension RecipeManager: RecipeIngredientsProtocol {
    
    func storeRecipeIngredient(withRecipeIdentifier recipeIdentifier: Int32, ingredientIdentifier: Int32, ingredientQuantity quantity: String) {
        
        let context = CoreDataManager.sharedInstance().mainContext!
        
        // retrieve the RecipeStep
        let entity =  NSEntityDescription.entity(forEntityName: "RecipeIngredient", in: context)
        
        let recipeIngredientStep = NSManagedObject(entity: entity!, insertInto: context)
        
        // set the entity values
        recipeIngredientStep.setValue(NSNumber.init(value: recipeIdentifier), forKey: "recipe_identifier")
        recipeIngredientStep.setValue(NSNumber.init(value: ingredientIdentifier), forKey: "ingredient_identifier")
        recipeIngredientStep.setValue(quantity, forKey: "quantity")
        
        // save the object
        CoreDataManager.sharedInstance().save(recipeIngredientStep)
    }
    
    func getRecipeIngredients(withRecipeIdentifier identifier: Int32) -> [RecipeIngredient]? {
        
        let context = CoreDataManager.sharedInstance().mainContext!
        
        // try to get a recipe ...
        let fetchRequest = NSFetchRequest<RecipeIngredient>(entityName: "RecipeIngredient")
        
        // ... with identifier
        fetchRequest.predicate = NSPredicate.init(format: "recipe_identifier == %d", identifier)
        
        do {
            //go get the results
            let searchResults = try context.fetch(fetchRequest)
            
            return searchResults
            
        } catch {
            print("Error with request: \(error)")
        }
        
        return nil
    }
    
    func hasRecipeIngredients(withRecipeIdentifier recipeIdentifier: Int32, ingredientIdentifier: Int32) -> Bool {
        
        let context = CoreDataManager.sharedInstance().mainContext!
        
        // try to get a recipe ...
        let fetchRequest = NSFetchRequest<RecipeIngredient>(entityName: "RecipeIngredient")
        
        // ... with identifier
        fetchRequest.predicate = NSPredicate.init(format: "recipe_identifier == %d AND ingredient_identifier == %d", recipeIdentifier, ingredientIdentifier)
        
        do {
            //go get the results
            let searchResults = try context.fetch(fetchRequest)
            
            return searchResults.count > 0
            
        } catch {
            print("Error with request: \(error)")
        }
        
        return false
    }
}

extension RecipeManager: IngredientsProtocol {
    
    func importIngredients() {
        
        let webservice = RecipeWebService()
        webservice.getAllIngredientJSONs(onCompletion: { ingredientJSONs in
            
            for ingredientJSON in ingredientJSONs! as [JSON] {
                let identifier = ingredientJSON["id"].int32Value
                NSLog("got recipe from web service: %d => %@", identifier, ingredientJSON["name"].stringValue)
                
                // try to fetch from internal storage
                var ingredient = self.getIngredient(withIdentifier: identifier)
                
                // create recipe if needed
                if ingredient == nil {
                    ingredient = self.storeIngredient(withIdentifier: identifier)
                    
                    // update or set values from dict
                    ingredient?.name = ingredientJSON["name"].stringValue
                    ingredient?.image_url = ingredientJSON["image_url"].stringValue
                    //ingredient?.type = ingredientJSON["type"].stringValue
                    
                    NSLog("ingredient created: %@", ingredientJSON["name"].stringValue)
                } else {
                    NSLog("ingredrient already exists: %@", ingredient ?? "<default>")
                }
            }
        })
    }
    
    func getIngredient(withIdentifier indentifier: Int32) -> Ingredient? {
        
        let context = CoreDataManager.sharedInstance().mainContext!
        
        // try to get a recipe ...
        let fetchRequest = NSFetchRequest<Ingredient>(entityName: "Ingredient")
        
        // ... with identifier
        fetchRequest.predicate = NSPredicate.init(format: "identifier == %d", indentifier)
        
        do {
            //go get the results
            let searchResults = try context.fetch(fetchRequest)
            
            if searchResults.count == 1 {
                return searchResults[0]
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        
        return nil
    }
    
    func storeIngredient(withIdentifier identifier: Int32) -> Ingredient? {
        
        let context = CoreDataManager.sharedInstance().mainContext!
        
        // retrieve the Ingredient
        let entity =  NSEntityDescription.entity(forEntityName: "Ingredient", in: context)
        
        let ingredient = NSManagedObject(entity: entity!, insertInto: context)
        
        // set the entity values
        ingredient.setValue(NSNumber.init(value: identifier), forKey: "identifier")
        
        // save the object
        CoreDataManager.sharedInstance().save(ingredient)
        print("saved ingredient!")
        return ingredient as? Ingredient
    }
    
    func allIngredients() -> [Ingredient]? {
        
        let context = CoreDataManager.sharedInstance().mainContext!
        
        let fetchRequest = NSFetchRequest<Ingredient>(entityName: "Ingredient")
        
        // ... with identifier
        fetchRequest.predicate = NSPredicate.init(value: true)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            // go get the results
            let searchResults = try context.fetch(fetchRequest)
            
            // I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")
            
            var ingredients: [Ingredient]? = []
            
            // You need to convert to NSManagedObject to use 'for' loops
            for ingredient in searchResults {
                //get the Key Value pairs (although there may be a better way to do that...
                //print("\(recipe.name)")
                ingredients?.append(ingredient)
            }
            
            return ingredients
        } catch {
            print("Error with request: \(error)")
        }
        
        return nil
    }
    
    func getRecipes(forIngredient ingredient: Int32) -> [Recipe]? {
        
        var recipesOfIngredient: [Recipe]? = []
        
        for recipe in self.allRecipes()! {
            if recipe.hasIngredient(withIdentifier: ingredient) {
                recipesOfIngredient?.append(recipe)
            }
        }
        
        return recipesOfIngredient
    }
}
