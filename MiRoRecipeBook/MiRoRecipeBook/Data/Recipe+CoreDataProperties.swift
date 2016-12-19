//
//  Recipe+CoreDataProperties.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 14.12.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe");
    }

    @NSManaged public var calories: Int32
    @NSManaged public var desc: String?
    @NSManaged public var identifier: Int32
    @NSManaged public var image_url: String?
    @NSManaged public var name: String?
    @NSManaged public var portions: Int32
    @NSManaged public var teaser: String?
    @NSManaged public var time: Int32
    @NSManaged public var country: String?
    @NSManaged public var flag_url: String?
    
}
