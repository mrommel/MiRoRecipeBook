//
//  RecipeCategory+CoreDataProperties.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 16.12.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension RecipeCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeCategory> {
        return NSFetchRequest<RecipeCategory>(entityName: "RecipeCategory");
    }

    @NSManaged public var recipe_identifier: Int32
    @NSManaged public var category_identifier: Int32

}
