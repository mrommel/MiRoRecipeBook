//
//  RecipesTableViewController.swift
//  MiRo.RecipeBook
//
//  Created by Michael Rommel on 22.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import UIKit
import MapleBacon

class RecipesTableViewController: UITableViewController {
    
    let recipeManager = RecipeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Recipes"
        
        let recipes = recipeManager.allRecipes()
        NSLog("recipes: %d", recipes!.count)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeManager.allRecipes()!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as UITableViewCell
        
        let recipe = self.getRecipe(withIndex: indexPath.row)
        cell.textLabel?.text = recipe.name
        
        var urlString = RestApiManager.baseURL + (recipe.image_url)!
        urlString = urlString.replacingOccurrences(of: "//", with: "/")
        let imageUrl = URL(string: urlString)
        let placeholder = UIImage(named: "recipe-default-image.png")
        cell.imageView?.setImage(withUrl: imageUrl!, placeholder: placeholder)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showRecipe", sender: self)
    }
    
    func getRecipe(withIndex index: Int) -> Recipe {

        let recipeItems = recipeManager.allRecipes()

        return recipeItems![index]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        NSLog("segue: %@", segue.identifier ?? "default")
        
        if segue.identifier == "showRecipe" {
            let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
            NSLog("selected row: %d", indexPath.row)
            let recipe = self.getRecipe(withIndex: indexPath.row)
            NSLog("selected recipe: %@", recipe)
            
            if let destinationViewController = segue.destination as? RecipeDetailViewController {
                destinationViewController.recipe = recipe
            }
        }
    }
    
    @IBAction func openMenu(_ sender: AnyObject) {
        self.revealViewController().revealToggle(nil)
    }
}
