//
//  RecipeIngredient+Parsing.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 13.12.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import CoreData

extension RecipeIngredient {
    
    override public var description : String {
        return "<RecipeIngredient recipe:\(self.recipe_identifier) ingredient:\(self.ingredient_identifier)>"
    }
    
    override public var debugDescription : String {
        return "<RecipeIngredient recipe:\(self.recipe_identifier) ingredient:\(self.ingredient_identifier)>"
    }
    
}
