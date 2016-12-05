//
//  Integrient+Parsing.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 05.12.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation
import CoreData

extension Integrient {
    
    override public var description : String {
        return "<Integrient \(self.name)>"
    }
    
    override public var debugDescription : String {
        return "<Integrient \(self.name)>"
    }
}

extension Integrient {
    
    func getImageUrl() -> URL? {
        var urlString = RestApiManager.baseURL + (self.image_url)!
        urlString = urlString.replacingOccurrences(of: "//", with: "/")
        let imageUrl = URL(string: urlString)
        return imageUrl
    }
    
}
