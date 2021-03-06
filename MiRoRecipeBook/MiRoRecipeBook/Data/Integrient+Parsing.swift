//
//  Ingredient+Parsing.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 05.12.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import Foundation
import CoreData

extension Ingredient {
    
    override public var description : String {
		return "<Ingredient \(String(describing: self.name))>"
    }
    
    override public var debugDescription : String {
		return "<Ingredient \(String(describing: self.name))>"
    }
}

extension Ingredient {
    
    func getImageUrl() -> URL? {
        
        if self.image_url == nil {
            return nil
        }
        
        var urlString = RestApiManager.baseURL + (self.image_url)!
        urlString = urlString.replacingOccurrences(of: "//", with: "/")
        let imageUrl = URL(string: urlString)
        return imageUrl
    }

    func getRecipeIngredients() -> [RecipeIngredient]? {
        
        return RecipeManager().getRecipeIngredients(withRecipeIdentifier: self.identifier)
    }
}
