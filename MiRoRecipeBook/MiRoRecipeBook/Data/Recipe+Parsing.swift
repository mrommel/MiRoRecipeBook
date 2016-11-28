//
//  Recipe+Parsing.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 27.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation

extension Recipe {
    
    func loadFromDictionary(_ dictionary: NSDictionary) {
        self.identifier = (dictionary["id"] as! NSNumber).stringValue
        self.name = dictionary["name"] as! String?
        self.teaser = dictionary["teaser"] as! String?
        self.desc = dictionary["description"] as! String?
    }
    
    func findOrCreateRecipeWithIdentifier(_ identifier: String) -> Recipe? {
        
        return nil
        /*let tempContext = CoreDataManager.sharedInstance.createWorkerContext()
        
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        var recipe: Recipe? = CoreDataManager.sharedInstance().fetch(withClassName: "Recipe", andPredicate: predicate, context: tempContext) as? Recipe
        
        if (recipe == nil) {
            recipe = CoreDataManager.sharedInstance().createNSManagedObject(forClassName: "Recipe", in: tempContext) as? Recipe
        }
        
        CoreDataManager.sharedInstance().save(tempContext)
        
        return recipe*/
    }
}
