//
//  RecipeIngredient+CoreDataProperties.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 14.12.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import Foundation
import CoreData


extension RecipeIngredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeIngredient> {
        return NSFetchRequest<RecipeIngredient>(entityName: "RecipeIngredient");
    }

    @NSManaged public var ingredient_identifier: Int32
    @NSManaged public var quantity: Float
    @NSManaged public var recipe_identifier: Int32
    @NSManaged public var type: String?
    @NSManaged public var order: Int32
}
