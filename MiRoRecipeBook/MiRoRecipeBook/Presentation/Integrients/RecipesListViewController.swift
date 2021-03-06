//
//  RecipesListViewController.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 13.12.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import UIKit

class RecipesListViewController: UITableViewController {
    
    var recipes: [Recipe]? // 
    var recipeListTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = self.recipeListTitle
    }
    
}

// MARK: UITableViewDelegate methods

extension RecipesListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
        let recipe = self.getRecipe(withIndex: indexPath.row)
        AppDelegate.shared?.appDependecies?.recipesWireframe?.presentDetail(forRecipe:recipe)
    }
    
    func getRecipe(withIndex index: Int) -> Recipe {
        
        return self.recipes![index]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x:0,y: 0,width: tableView.frame.size.width,height: 12))
        footerView.backgroundColor = ColorPalette.gray25
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x:0,y: 0,width: tableView.frame.size.width,height: 12))
        footerView.backgroundColor = ColorPalette.gray25
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12.0
    }
    
}

// MARK: UITableViewDataSource methods

extension RecipesListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell
        
        let recipe = self.getRecipe(withIndex: indexPath.row)
        cell.recipeTitleLabel?.text = recipe.name
        cell.recipeDescriptionLabel?.text = recipe.teaser
        
		cell.recipeImageView?.setImage(with: recipe.getImageUrl()!, placeholder: UIImage(named: "recipe-default-image.png"))
        
        return cell
    }
    
}
