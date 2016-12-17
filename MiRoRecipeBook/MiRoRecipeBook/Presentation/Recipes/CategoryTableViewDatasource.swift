//
//  CategoryTableViewDatasource.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 16.12.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import UIKit

class CategoryTableViewDatasource: NSObject, UITableViewDataSource {
    
    let recipeManager = RecipeManager()
    var recipe: Recipe?
    var categories: [Category]?
    
    init(forRecipe recipe: Recipe?) {
        super.init()
        
        self.recipe = recipe
        self.categories = recipeManager.getCategories(withRecipeIdentifier: (self.recipe!.identifier))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categoryNumber = self.categories!.count
        return categoryNumber
    }
    
    func getRecipeCategory(withIndex index: Int) -> Category {
        return self.categories![index]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        
        cell.selectionStyle = .none
        
        let title = self.getRecipeCategory(withIndex: indexPath.row).name
        cell.textLabel?.text = title
        NSLog("title: \(title)")
        
        return cell
    }
}