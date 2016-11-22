//
//  MenuTableViewController.swift
//  MiRo.RecipeBook
//
//  Created by Michael Rommel on 22.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import UIKit

struct Bird{
    var name:String!
}

class MenuTableViewController: UITableViewController {

    var birds: [Bird] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        birds.append(Bird(name: "Recipes"))
        birds.append(Bird(name: "Categories"))
        birds.append(Bird(name: "Integrients"))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = birds[indexPath.row].name
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            let recipesTableViewController = storyboard?.instantiateViewController(withIdentifier: "recipesTableViewController") as! RecipesTableViewController
            self.revealViewController().pushFrontViewController(recipesTableViewController, animated: true)
            
            break;
        default:
            break;
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x:0,y: 0,width: tableView.frame.size.width,height: 1))
        footerView.backgroundColor = UIColor.blue
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
}
