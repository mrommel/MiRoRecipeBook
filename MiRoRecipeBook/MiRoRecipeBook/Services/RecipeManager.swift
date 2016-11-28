//
//  RecipeManager.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 27.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import CoreData

class RecipeManager: CoreDataManager {
    
    fileprivate var webservice: RecipeWebService?
    
    func importRecipes() {
        
        let webservice = RecipeWebService()
        webservice.getAllRecipes(onCompletion: { recipes in
            
            for recipe in recipes! {
                NSLog("got recipe: %@", recipe)
            }
        })
        
    }
    
    func storeRecipe(identifier: String, name: String) {
        
        let context = getContext()
        
        // retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "Recipe", in: context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        // set the entity values
        transc.setValue(identifier, forKey: "identifier")
        transc.setValue(name, forKey: "name")
        
        // save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    func allRecipes() -> [Recipe]? {
    
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest() as! NSFetchRequest<Recipe>

        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            
            //I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")
            
            var recipes: [Recipe]? = []
            
            //You need to convert to NSManagedObject to use 'for' loops
            for recipe in searchResults as [NSManagedObject] {
                //get the Key Value pairs (although there may be a better way to do that...
                print("\(recipe.value(forKey: "name"))")
                
                recipes?.append(recipe as! Recipe)
            }
            
            return recipes
        } catch {
            print("Error with request: \(error)")
        }
     
        return nil
    }
}
