//
//  Recipe.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 27.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation
import CoreData

@objc(Recipe)
class Recipe: NSManagedObject {
    
    @NSManaged var identifier: String?
    @NSManaged var name: String?
    @NSManaged var teaser: String?
    @NSManaged var desc: String?

}
