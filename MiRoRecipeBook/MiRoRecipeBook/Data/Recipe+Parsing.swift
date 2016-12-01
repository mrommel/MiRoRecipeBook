//
//  Recipe+Parsing.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 27.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation
import CoreData

extension Recipe {
    
    override public var description : String {
        return "<Recipe \(self.name)>"
    }
    
    override public var debugDescription : String {
        return "<Recipe \(self.name)>"
    }
}

extension Recipe {
    
    /*func loadFromDictionary(_ dictionary: NSDictionary) {
        self.identifier = (dictionary["id"] as! NSNumber).stringValue
        self.name = dictionary["name"] as! String?
        self.teaser = dictionary["teaser"] as! String?
        self.desc = dictionary["description"] as! String?
    }*/

    
}
