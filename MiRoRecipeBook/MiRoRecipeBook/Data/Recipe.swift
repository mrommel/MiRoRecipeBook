//
//  Recipe.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 30.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation
import CoreData

public class Recipe: NSManagedObject {
    
    @NSManaged var identifier: NSNumber?
    @NSManaged var name: String?
    @NSManaged var teaser: String?
    @NSManaged var desc: String?
    @NSManaged var image_url: String?
    
    @NSManaged var portions: NSNumber?
    @NSManaged var calories: NSNumber?
    @NSManaged var time: NSNumber?
}
