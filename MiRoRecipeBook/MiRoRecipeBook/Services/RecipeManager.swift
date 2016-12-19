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

protocol DataImportProtocol: class {
    
    func importData(successBlock: (() -> Void)?, onError errorBlock: ErrorResponse?)
    func importRecipes(successBlock: (() -> Void)?, onError errorBlock: ErrorResponse?)
    func importIngredients(successBlock: (() -> Void)?, onError errorBlock: ErrorResponse?)
    func importCategories(successBlock: (() -> Void)?, onError errorBlock: ErrorResponse?)
    
    func clearData(successBlock: (() -> Void)?)
}

protocol RecipesProtocol: class {
    
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
    
    func getIngredient(withIdentifier indentifier: Int32) -> Ingredient?
    func allIngredients() -> [Ingredient]?
    func getRecipes(forIngredient ingredient: Int32) -> [Recipe]?
}

protocol CategoriesProtocol: class {
    
    func getCategory(withIdentifier indentifier: Int32) -> Category?
    func storeCategory(withIdentifier identifier: Int32, name: String, image: String, path: String, parent: Int32, recipes: Int32) -> Category?
    func allCategories() -> [Category]?
    
    func storeRecipeCategory(withRecipeIdentifier identifier: Int32, categoryIdentifier: Int32)
    func getCategories(forIdentifier identifier: Int32) -> [Category]?
    func getRecipeCategories(forIdentifier identifier: Int32) -> [RecipeCategory]?
}

class RecipeManager: NSObject {
    
    fileprivate var webservice: RecipeWebService?
}

extension RecipeManager: DataImportProtocol {
    
    func clearData(successBlock: (() -> Void)?) {
        for recipe in self.allRecipes()! {
            
            // delete steps of recipe
            for step in recipe.getSteps()! {
                CoreDataManager.sharedInstance().delete(step)
            }
            
            // delete recipe ingredients
            for recipeIngredient in recipe.getRecipeIngredients()! {
                CoreDataManager.sharedInstance().delete(recipeIngredient)
            }
            
            // delete recipe categories
            for recipeCategory in recipe.getRecipeCategories()! {
                CoreDataManager.sharedInstance().delete(recipeCategory)
            }
            
            CoreDataManager.sharedInstance().delete(recipe)
        }
        
        for ingredient in self.allIngredients()! {
            CoreDataManager.sharedInstance().delete(ingredient)
        }
        
        for category in self.allCategories()! {
            CoreDataManager.sharedInstance().delete(category)
        }
        
        successBlock?()
    }
    
    func importData(successBlock: (() -> Void)?, onError errorBlock: ErrorResponse?) {
        self.importIngredients(successBlock: {
            self.importRecipes(successBlock: {
                self.importCategories(successBlock: {
                    successBlock?()
                }, onError: { (error) in
                    errorBlock?(error)
                })
            }, onError: { (error) in
                errorBlock?(error)
            })
        }, onError: { (error) in
            errorBlock?(error)
        })
    }
    
    func importRecipes(successBlock: (() -> Void)?, onError errorBlock: ErrorResponse?) {
        
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
                    
                    let countriesJson = recipeJSON["countries"]
                    let country = countriesJson["country"]
                    
                    recipe?.country = country["name"].stringValue
                    recipe?.flag_url = country["flag"].stringValue
                    
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
                    
                    for categoryJSON in recipeJSON["categories"].array! as [JSON] {
                        let categoryIdentifier = categoryJSON["id"].int32Value
                        NSLog("create category link \(identifier) \(categoryIdentifier)")
                        self.storeRecipeCategory(withRecipeIdentifier: identifier, categoryIdentifier: categoryIdentifier)
                    }
                    
                    NSLog("recipe created: %@", recipeJSON["name"].stringValue)
                } else {
                    NSLog("recipe already exists: %@", recipe ?? "<default>")
                }
            }
            
            CoreDataManager.sharedInstance().saveContext()
            
            successBlock?()
        }, onError: { err in
            errorBlock?(err)
        })
    }
    
    func importIngredients(successBlock: (() -> Void)?, onError errorBlock: ErrorResponse?) {
        
        let webservice = RecipeWebService()
        webservice.getAllIngredientJSONs(onCompletion: { ingredientJSONs in
            
            for ingredientJSON in ingredientJSONs! as [JSON] {
                let identifier = ingredientJSON["id"].int32Value
                NSLog("got recipe from web service: %d => %@", identifier, ingredientJSON["name"].stringValue)
                
                // try to fetch from internal storage
                var ingredient = self.getIngredient(withIdentifier: identifier)
                
                // create recipe if needed
                if ingredient == nil {
                    let name = ingredientJSON["name"].stringValue
                    let imageUrl = ingredientJSON["image_url"].stringValue
                    
                    ingredient = self.storeIngredient(withIdentifier: identifier, name: name, imageUrl: imageUrl)
                    
                    NSLog("ingredient created: %@", name)
                } else {
                    NSLog("ingredrient already exists: %@", ingredient ?? "<default>")
                }
            }
            
            CoreDataManager.sharedInstance().saveContext()
            
            successBlock?()
        }, onError: { err in
            errorBlock?(err)
        })
    }
    
    func importCategories(successBlock: (() -> Void)?, onError errorBlock: ErrorResponse?) {
        
        let webservice = RecipeWebService()
        webservice.getAllCategoryJSONs(onCompletion: { categoryJSONs in
            
            for categoryJSON in categoryJSONs! as [JSON] {
                let identifier = categoryJSON["id"].int32Value
                NSLog("got category from web service: %d => %@", identifier, categoryJSON["name"].stringValue)
                
                // try to fetch from internal storage
                var category = self.getCategory(withIdentifier: identifier)
                
                // create recipe if needed
                if category == nil {
                    let name = categoryJSON["name"].stringValue
                    let parent = categoryJSON["parent_id"].int32Value
                    let path = categoryJSON["path"].stringValue
                    let recipies = categoryJSON["number_of_receipts"].int32Value
                    let image = categoryJSON["image_url"].stringValue
                    
                    category = self.storeCategory(withIdentifier: identifier, name: name, image: image, path: path, parent: parent, recipes: recipies)
                    
                    NSLog("category created: %@", name)
                } else {
                    NSLog("category already exists: %@", category ?? "<default>")
                }
            }
            
            CoreDataManager.sharedInstance().saveContext()
            
            successBlock?()
        }, onError: { err in
            errorBlock?(err)
        })
    }
}

extension RecipeManager: RecipesProtocol {
    
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
        let recipe = CoreDataManager.sharedInstance().createNSManagedObject(for: Recipe.self) as? Recipe
        
        // set the entity values
        recipe?.identifier = identifier
        
        // save the object
        print("recipe \(recipe) created!")
        return recipe
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
        
        // retrieve the RecipeStep
        let recipeStep = CoreDataManager.sharedInstance().createNSManagedObject(for: RecipeStep.self) as? RecipeStep
        
        // set the entity values
        recipeStep?.recipe_identifier = identifier
        recipeStep?.step = step
        
        // save the object
        print("recipeStep created!")
        return recipeStep
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
    
    func storeIngredient(withIdentifier identifier: Int32, name: String, imageUrl: String) -> Ingredient? {
        
        let tempContext = CoreDataManager.sharedInstance().createWorkerContext()
        
        // retrieve the Ingredient
        let ingredient = CoreDataManager.sharedInstance().createNSManagedObject(forClassName: Ingredient.nameOfClass, in: tempContext) as? Ingredient
        
        // set the entity values
        ingredient?.identifier = identifier
        ingredient?.name = name
        ingredient?.image_url = imageUrl
        
        // save the object
        CoreDataManager.sharedInstance().save(tempContext)
        print("saved ingredient!")
        return ingredient
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

extension RecipeManager: CategoriesProtocol {
    
    func getCategory(withIdentifier indentifier: Int32) -> Category? {
        
        let context = CoreDataManager.sharedInstance().mainContext!
        
        // try to get a recipe ...
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        
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
    
    func storeCategory(withIdentifier identifier: Int32, name: String, image: String, path: String, parent: Int32, recipes: Int32) -> Category? {
        
        let tempContext = CoreDataManager.sharedInstance().createWorkerContext()
        
        // retrieve the Ingredient
        let category = CoreDataManager.sharedInstance().createNSManagedObject(forClassName: Category.nameOfClass, in: tempContext) as? Category
        
        // set the entity values
        category?.identifier = identifier
        category?.name = name
        category?.parent = parent
        category?.path = path
        category?.recipes = recipes
        category?.image_url = image
        
        // save the object
        CoreDataManager.sharedInstance().save(tempContext)
        print("saved category!")
        return category
    }

    func allCategories() -> [Category]? {
        
        let context = CoreDataManager.sharedInstance().mainContext!
        
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        
        // ... with identifier
        fetchRequest.predicate = NSPredicate.init(value: true)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            // go get the results
            let searchResults = try context.fetch(fetchRequest)
            
            // I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")
            
            var categories: [Category]? = []
            
            // You need to convert to NSManagedObject to use 'for' loops
            for category in searchResults {
                //get the Key Value pairs (although there may be a better way to do that...
                //print("\(recipe.name)")
                categories?.append(category)
            }
            
            return categories
        } catch {
            print("Error with request: \(error)")
        }
        
        return nil
    }
    
    func getCategories(forIdentifier identifier: Int32) -> [Category]? {
    
        let context = CoreDataManager.sharedInstance().mainContext!
        
        // try to get a recipe ...
        let fetchRequest = NSFetchRequest<RecipeCategory>(entityName: "RecipeCategory")
        
        // ... with identifier
        fetchRequest.predicate = NSPredicate.init(format: "recipe_identifier == %d", identifier)
        
        do {
            //go get the results
            let searchResults = try context.fetch(fetchRequest)
            var categories: [Category]? = []
            
            for recipeCategory in searchResults {
                categories?.append(self.getCategory(withIdentifier: recipeCategory.category_identifier)!)
            }
            
            return categories
            
        } catch {
            print("Error with request: \(error)")
        }
        
        return nil
    }

    func getRecipeCategories(forIdentifier identifier: Int32) -> [RecipeCategory]? {
        
        let context = CoreDataManager.sharedInstance().mainContext!
        
        // try to get a recipe ...
        let fetchRequest = NSFetchRequest<RecipeCategory>(entityName: "RecipeCategory")
        
        // ... with identifier
        fetchRequest.predicate = NSPredicate.init(format: "recipe_identifier == %d", identifier)
        
        do {
            //go get the results
            let searchResults = try context.fetch(fetchRequest)
            
            return searchResults as [RecipeCategory]?
            
        } catch {
            print("Error with request: \(error)")
        }
        
        return nil
    }

    
    func storeRecipeCategory(withRecipeIdentifier identifier: Int32, categoryIdentifier: Int32) {
     
        let tempContext = CoreDataManager.sharedInstance().createWorkerContext()
        
        // retrieve the Ingredient
        let recipeCategory = CoreDataManager.sharedInstance().createNSManagedObject(forClassName: RecipeCategory.nameOfClass, in: tempContext) as? RecipeCategory
        
        // set the entity values
        recipeCategory?.recipe_identifier = identifier
        recipeCategory?.category_identifier = categoryIdentifier
        
        // save the object
        CoreDataManager.sharedInstance().save(tempContext)
        print("saved recipeCategory!")
        return
    }

}
