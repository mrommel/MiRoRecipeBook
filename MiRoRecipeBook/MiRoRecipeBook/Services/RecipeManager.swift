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
    func getRecipe(withIdentifier indentifier: Int) -> Recipe?
    func storeRecipe(withIdentifier identifier: Int) -> Recipe?
    func allRecipes() -> [Recipe]?
}

protocol IntegrientsProtocol: class {
    
    func importIntegrients()
    func getIntegrient(withIdentifier indentifier: Int) -> Integrient?
    func allIntegrients() -> [Integrient]?
}

class RecipeManager: CoreDataManager {
    
    fileprivate var webservice: RecipeWebService?
}

extension RecipeManager: RecipesProtocol {
    
    func importRecipes() {
        
        let webservice = RecipeWebService()
        webservice.getAllRecipeJSONs(onCompletion: { recipeJSONs in
            
            for recipeJSON in recipeJSONs! as [JSON] {
                let identifier = recipeJSON["id"].intValue
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
                    recipe?.calories = recipeJSON["calories"].numberValue
                    recipe?.time = recipeJSON["time"].numberValue
                    recipe?.portions = recipeJSON["portions"].numberValue
                    
                    for stepJSON in recipeJSON["steps"].array! as [JSON] {
                        //NSLog("step %@", stepJSON.stringValue)
                        let _ = self.storeRecipeStep(withIdentifier: identifier, step: stepJSON.stringValue)
                    }
                    
                    NSLog("recipe created: %@", recipeJSON["name"].stringValue)
                } else {
                    NSLog("recipe already exists: %@", recipe ?? "<default>")
                }
            }
        })
    }
    
    func getRecipe(withIdentifier indentifier: Int) -> Recipe? {
        
        let context = getContext()
        
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
    
    func storeRecipeStep(withIdentifier identifier: Int, step: String) -> RecipeStep? {
        
        let context = self.getContext()
        
        // retrieve the RecipeStep
        let entity =  NSEntityDescription.entity(forEntityName: "RecipeStep", in: context)
        
        let recipeStep = NSManagedObject(entity: entity!, insertInto: context)
        
        // set the entity values
        recipeStep.setValue(NSNumber.init(value: identifier), forKey: "recipe_identifier")
        recipeStep.setValue(step, forKey: "step")
        
        // save the object
        do {
            try context.save()
            print("saved!")
            return recipeStep as? RecipeStep
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            return nil
        } catch {
            return nil
        }
    }
    
    func storeRecipe(withIdentifier identifier: Int) -> Recipe? {
        
        let context = self.getContext()
        
        // retrieve the Recipe
        let entity =  NSEntityDescription.entity(forEntityName: "Recipe", in: context)
        
        let recipe = NSManagedObject(entity: entity!, insertInto: context)
        
        // set the entity values
        recipe.setValue(NSNumber.init(value: identifier), forKey: "identifier")
        
        // save the object
        do {
            try context.save()
            print("saved!")
            return recipe as? Recipe
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            return nil
        } catch {
            return nil
        }
    }
    
    func getRecipeSteps(withIdentifier identifier: Int) -> [RecipeStep]? {
        return nil
    }
    
    func allRecipes() -> [Recipe]? {
        
        let fetchRequest = NSFetchRequest<Recipe>(entityName: "Recipe")
        
        // ... with identifier
        fetchRequest.predicate = NSPredicate.init(value: true)
        
        do {
            // go get the results
            let searchResults = try self.getContext().fetch(fetchRequest)
            
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

extension RecipeManager: IntegrientsProtocol {
    
    func importIntegrients() {
        
        let webservice = RecipeWebService()
        webservice.getAllIntegrientJSONs(onCompletion: { integrientJSONs in
            
            for integrientJSON in integrientJSONs! as [JSON] {
                let identifier = integrientJSON["id"].intValue
                NSLog("got recipe from web service: %d => %@", identifier, integrientJSON["name"].stringValue)
                
                // try to fetch from internal storage
                var integrient = self.getIntegrient(withIdentifier: identifier)
                
                // create recipe if needed
                if integrient == nil {
                    integrient = self.storeIntegrient(withIdentifier: identifier)
                    
                    // update or set values from dict
                    integrient?.name = integrientJSON["name"].stringValue
                    integrient?.image_url = integrientJSON["image_url"].stringValue
                    //integrient?.type = integrientJSON["type"].stringValue
                    
                    NSLog("integrient created: %@", integrientJSON["name"].stringValue)
                } else {
                    NSLog("integrient already exists: %@", integrient ?? "<default>")
                }
            }
        })
    }
    
    func getIntegrient(withIdentifier indentifier: Int) -> Integrient? {
        
        let context = getContext()
        
        // try to get a recipe ...
        let fetchRequest = NSFetchRequest<Integrient>(entityName: "Integrient")
        
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
    
    func storeIntegrient(withIdentifier identifier: Int) -> Integrient? {
        
        let context = self.getContext()
        
        // retrieve the Integrient
        let entity =  NSEntityDescription.entity(forEntityName: "Integrient", in: context)
        
        let recipe = NSManagedObject(entity: entity!, insertInto: context)
        
        // set the entity values
        recipe.setValue(NSNumber.init(value: identifier), forKey: "identifier")
        
        // save the object
        do {
            try context.save()
            print("saved!")
            return recipe as? Integrient
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            return nil
        } catch {
            return nil
        }
    }
    
    func allIntegrients() -> [Integrient]? {
        
        let fetchRequest = NSFetchRequest<Integrient>(entityName: "Integrient")
        
        // ... with identifier
        fetchRequest.predicate = NSPredicate.init(value: true)
        
        do {
            // go get the results
            let searchResults = try self.getContext().fetch(fetchRequest)
            
            // I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")
            
            var integrients: [Integrient]? = []
            
            // You need to convert to NSManagedObject to use 'for' loops
            for integrient in searchResults {
                //get the Key Value pairs (although there may be a better way to do that...
                //print("\(recipe.name)")
                integrients?.append(integrient)
            }
            
            return integrients
        } catch {
            print("Error with request: \(error)")
        }
        
        return nil
    }
}
