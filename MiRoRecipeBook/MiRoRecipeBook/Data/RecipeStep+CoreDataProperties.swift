//
//  RecipeStep+CoreDataProperties.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 14.12.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import Foundation
import CoreData


extension RecipeStep {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeStep> {
        return NSFetchRequest<RecipeStep>(entityName: "RecipeStep");
    }

    @NSManaged public var recipe_identifier: Int32
    @NSManaged public var index: Int32
    @NSManaged public var text: String?

}
