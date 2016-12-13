//
//  RecipeIngredient.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 13.12.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import CoreData

public class RecipeIngredient: NSManagedObject {
    
    @NSManaged var recipe_identifier: NSNumber?
    @NSManaged var ingredient_identifier: NSNumber?
    @NSManaged var quantity: String?

}
