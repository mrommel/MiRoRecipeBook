//
//  Category+CoreDataProperties.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 16.12.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category");
    }

    @NSManaged public var identifier: Int32
    @NSManaged public var name: String?
    @NSManaged public var path: String?
    @NSManaged public var parent: Int32
    @NSManaged public var recipes: Int32
    @NSManaged public var image_url: String?
}
