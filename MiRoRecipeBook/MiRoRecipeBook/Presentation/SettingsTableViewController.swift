//
//  SettingsTableViewController.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 23.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var recipes: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Settings"
        
        recipes.append("Sync")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as UITableViewCell
        cell.imageView?.image = UIImage.init(named: "sync-64.png")
        cell.textLabel?.text = recipes[indexPath.row]
        // Configure the cell...
        
        return cell
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            let recipeManager = RecipeManager()
            recipeManager.importRecipes()
            recipeManager.importIntegrients()
            
            self.tableView.deselectRow(at: indexPath, animated: true)
            break;
        default:
            break;
        }
    }
    
    @IBAction func openMenu(_ sender: AnyObject) {
        self.revealViewController().revealToggle(nil)
    }
}
