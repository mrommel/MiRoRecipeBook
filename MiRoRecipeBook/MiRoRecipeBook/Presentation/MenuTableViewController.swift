//
//  MenuTableViewController.swift
//  MiRo.RecipeBook
//
//  Created by Michael Rommel on 22.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import UIKit

struct MenuItem {
    var image: String!
    var name: String!
    var identifier: String!
}

class MenuTableViewController: UITableViewController {

    var menuItems: [MenuItem] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        menuItems.append(MenuItem(image: "ingredients-64.png", name: "Recipes", identifier:"recipesTableViewController"))
        menuItems.append(MenuItem(image: "ingredients-64.png", name: "Categories", identifier:""))
        menuItems.append(MenuItem(image: "ingredients-64.png", name: "Integrients", identifier:"integrientsTableViewController"))
        menuItems.append(MenuItem(image: "", name: "", identifier:""))
        menuItems.append(MenuItem(image: "ingredients-64.png", name: "Settings", identifier:"settingsViewController"))
        
        self.title = "RecipeBook"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as UITableViewCell
        cell.imageView?.image = UIImage.init(named: menuItems[indexPath.row].image)
        cell.textLabel?.text = menuItems[indexPath.row].name
        cell.detailTextLabel?.text = "test"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if menuItems[indexPath.row].identifier.isEmpty {
            return;
        }
        
        let targetViewController = storyboard?.instantiateViewController(withIdentifier: menuItems[indexPath.row].identifier)
        self.revealViewController().pushFrontViewController(targetViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView(frame: CGRect(x:0,y: 0,width: tableView.frame.size.width,height: 1))
        footerView.backgroundColor = UIColor.white
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
}
