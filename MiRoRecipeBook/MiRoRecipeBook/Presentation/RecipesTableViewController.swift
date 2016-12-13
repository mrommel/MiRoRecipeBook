//
//  RecipesTableViewController.swift
//  MiRo.RecipeBook
//
//  Created by Michael Rommel on 22.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import UIKit
import MapleBacon

class RecipeTableViewCell: UITableViewCell {
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeDescriptionLabel: UILabel!
}

class RecipesTableViewController: UITableViewController {
    
    let recipeManager = RecipeManager()
    var recipes: [Recipe]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Recipes"
        
        self.recipes = recipeManager.allRecipes()
        NSLog("recipes: %d", recipes!.count)
    }

}

// MARK: UITableViewDelegate methods

extension RecipesTableViewController {
    
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

extension RecipesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell
        
        let recipe = self.getRecipe(withIndex: indexPath.row)
        cell.recipeTitleLabel?.text = recipe.name
        cell.detailTextLabel?.text = recipe.desc
        
        cell.recipeImageView?.setImage(withUrl: recipe.getImageUrl()!, placeholder: UIImage(named: "recipe-default-image.png"), crossFadePlaceholder: false, cacheScaled: false)
        
        return cell
    }
    
}

