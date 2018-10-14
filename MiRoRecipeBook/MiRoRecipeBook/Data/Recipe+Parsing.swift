//
//  Recipe+Parsing.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 27.11.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import Foundation
import CoreData

extension Recipe {
    
    override public var description : String {
		return "<Recipe \(String(describing: self.name))>"
    }
    
    override public var debugDescription : String {
		return "<Recipe \(String(describing: self.name))>"
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
        return RecipeManager().hasRecipeIngredient(withRecipeIdentifier: self.identifier, ingredientIdentifier: ingredientIdentifier)
    }
    
    func getRecipeIngredients() -> [RecipeIngredient]? {        
        return RecipeManager().getRecipeIngredients(withRecipeIdentifier: self.identifier)
    }
    
    func getCategories() -> [Category]? {
        return RecipeManager().getCategories(forIdentifier: self.identifier)
    }
    
    func getRecipeCategories() -> [RecipeCategory]? {
        return RecipeManager().getRecipeCategories(forIdentifier: self.identifier)
    }
    
    func hasCategory(withIdentifier categoryIdentifier: Int32) -> Bool {
        return RecipeManager().hasRecipeCategory(withRecipeIdentifier: self.identifier, categoryIdentifier: categoryIdentifier)
    }
}
