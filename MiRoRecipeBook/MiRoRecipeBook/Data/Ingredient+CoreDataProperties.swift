//
//  Ingredient+CoreDataProperties.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 14.12.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient");
    }

    @NSManaged public var identifier: Int32
    @NSManaged public var image_url: String?
    @NSManaged public var name: String?
    @NSManaged public var type: String?

}
