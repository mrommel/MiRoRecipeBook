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
    
    func getImageUrl() -> URL? {
        var urlString = RestApiManager.baseURL + (self.image_url)!
        urlString = urlString.replacingOccurrences(of: "//", with: "/")
        let imageUrl = URL(string: urlString)
        return imageUrl
    }
}
