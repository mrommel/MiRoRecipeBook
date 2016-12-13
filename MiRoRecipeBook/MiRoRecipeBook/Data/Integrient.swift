//
//  Ingredient.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 05.12.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation
import CoreData

public class Ingredient: NSManagedObject {
    
    @NSManaged var identifier: NSNumber?
    @NSManaged var name: String?
    @NSManaged var image_url: String?
    @NSManaged var type: String?

}
