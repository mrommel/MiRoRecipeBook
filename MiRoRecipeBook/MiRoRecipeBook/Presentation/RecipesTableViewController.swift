//
//  RecipesTableViewController.swift
//  MiRo.RecipeBook
//
//  Created by Michael Rommel on 22.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import UIKit

class RecipesTableViewController: UITableViewController {
    
    var recipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Recipes"
        
        let recipeWebservice = RecipeWebService()
        let recipeManager = RecipeManager(context:CoreDataManager.sharedInstance().mainContext, webservice:recipeWebservice)
        
        let allRecipes = recipeManager?.allRecipes() as! [Recipe]
        for (_, obj) in allRecipes.enumerated() {
            recipes.append(obj)
        }
        
        NSLog("recipes: %d", recipes.count)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = recipes[indexPath.row].name
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showRecipe", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("segue: %@", segue.identifier ?? "default")
        
        if segue.identifier == "showRecipe" {
            let indexPath = self.tableView.indexPathForSelectedRow;
            let recipe = recipes[(indexPath?.row)!];
            let viewController = segue.destination as! RecipeDetailViewController;
            viewController.recipe = recipe;
        }
    }
    
    @IBAction func openMenu(_ sender: AnyObject) {
        self.revealViewController().revealToggle(nil)
    }
}
