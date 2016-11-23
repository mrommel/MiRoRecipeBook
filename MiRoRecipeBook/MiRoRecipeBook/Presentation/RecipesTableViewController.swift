//
//  RecipesTableViewController.swift
//  MiRo.RecipeBook
//
//  Created by Michael Rommel on 22.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import UIKit

class RecipesTableViewController: UITableViewController {
    
    var recipes: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Recipes"
        
        recipes.append("abc")
        recipes.append("def")
        recipes.append("efd")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = recipes[indexPath.row]
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            break;
        default:
            break;
        }
    }
    
    @IBAction func openMenu(_ sender: AnyObject) {
        self.revealViewController().revealToggle(nil)
    }
}
