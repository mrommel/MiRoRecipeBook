//
//  RecipeStep.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 30.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation
import CoreData

public class RecipeStep: NSManagedObject {
    
    @NSManaged var recipe_identifier: NSNumber?
    @NSManaged var step: String?

}
