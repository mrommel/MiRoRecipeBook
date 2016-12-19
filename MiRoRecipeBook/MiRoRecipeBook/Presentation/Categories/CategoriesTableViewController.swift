//
//  CategoriesTableViewController.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 18.12.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation

class CategoryGroup: NSObject {
    
    var cagetoryId: Int32
    var categoryName: String
    var children: [CategoryGroup] = []
    
    init(withId identifier: Int32, andName name: String) {
       
        self.cagetoryId = identifier
        self.categoryName = name
    }
}

class CategoryGroupManager: NSObject {

    let recipeManager = RecipeManager()
    static let sharedInstance = CategoryGroupManager()

    func getCategoryGroups() -> [CategoryGroup]? {
        
        // prepare the coutput
        var categoryGroups: [CategoryGroup]? = []
        
        // get source categories
        let categories = recipeManager.allCategories()
        NSLog("categories: %d", categories!.count)
        
        // find root categories
        for category in categories! {
            if category.parent == Category.kNoCategory {
                categoryGroups?.append(CategoryGroup.init(withId: category.identifier, andName: category.name!))
                NSLog("added: \(category.name!)")
            }
        }
        
        // add the categories that belong to them
        for category in categories! {
            if category.parent != Category.kNoCategory {
                //self.categoryGroups?.append(CategoryGroup.init(withId: category.identifier, andName: category.name!))
                //NSLog("added: \(category.name!)")
                for categoryGroup in categoryGroups! {
                    if categoryGroup.cagetoryId == category.parent {
                        categoryGroup.children.append(CategoryGroup.init(withId: category.identifier, andName: category.name!))
                    }
                }
            }
        }
        
        return categoryGroups
    }
    
}

class CategoriesTableViewController: UITableViewController {
    
    var categoryGroups: [CategoryGroup]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Categories".localized
        
        // fetch the data
        self.categoryGroups = CategoryGroupManager.sharedInstance.getCategoryGroups()
        
        self.tableView.sectionIndexBackgroundColor = ColorPalette.gray25
    }
    
    func getCategoryGroup(forSection section: Int, andRow row: Int) -> CategoryGroup {
        return self.categoryGroups![section].children[row]
    }
    
    func getCategoryGroup(forSection section: Int) -> CategoryGroup {
        return self.categoryGroups![section]
    }
    
}

// MARK: UITableViewDelegate methods

extension CategoriesTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
        //let recipe = self.getCategory(withIndex: indexPath.row)
        // AppDelegate.shared?.appDependecies?.recipesWireframe?.presentDetail(forRecipe:recipe)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let categoryGroup = self.getCategoryGroup(forSection: section)
        return categoryGroup.categoryName
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
        return 35.0
    }
    
}

// MARK: UITableViewDataSource methods

extension CategoriesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.categoryGroups![section] as CategoryGroup
        
        return section.children.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.categoryGroups!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! RecipeTableViewCell
        
        let categoryGroup = self.getCategoryGroup(forSection: indexPath.section, andRow: indexPath.row)
        
        cell.recipeTitleLabel?.text = categoryGroup.categoryName
        cell.recipeDescriptionLabel?.text = "test"
        
        return cell
    }
    
}
