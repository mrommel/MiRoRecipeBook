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
        if self.image_url == nil {
            return nil
        }
        
        var urlString = RestApiManager.baseURL + (self.image_url)!
        urlString = urlString.replacingOccurrences(of: "//", with: "/")
        let imageUrl = URL(string: urlString)
        return imageUrl
    }
    
    func getFlagUrl() -> URL? {
        if self.flag_url == nil {
            return nil
        }
        
        var urlString = RestApiManager.baseURL + (self.flag_url)!
        urlString = urlString.replacingOccurrences(of: "//", with: "/")
        let imageUrl = URL(string: urlString)
        return imageUrl
    }
    
    func getSteps() -> [RecipeStep]? {
        
        return RecipeManager().getRecipeSteps(withRecipeIdentifier: self.identifier)
    }
    
    func hasIngredient(withIdentifier ingredientIdentifier: Int32) -> Bool {
        return RecipeManager().hasRecipeIngredients(withRecipeIdentifier: self.identifier, ingredientIdentifier: ingredientIdentifier)
    }
    
    func getRecipeIngredients() -> [RecipeIngredient]? {
        
        return RecipeManager().getRecipeIngredients(withRecipeIdentifier: self.identifier)
    }
}
