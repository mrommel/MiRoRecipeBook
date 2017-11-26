//
//  MenuTableViewController.swift
//  MiRo.RecipeBook
//
//  Created by Michael Rommel on 22.11.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import UIKit

enum ScreenType {
    case recipes
    case ingredients
    case categories
    case settings
}

struct MenuItem {
    var image: String!
    var name: String!
    var screenType: ScreenType!
}

class MenuTableViewController: UITableViewController {

    var menuItems: [MenuItem] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        menuItems.append(MenuItem(image: "menu-recipe.png", name: "Recipes".localized, screenType:ScreenType.recipes))
        menuItems.append(MenuItem(image: "menu-ingredients.png", name: "Ingredients".localized, screenType:ScreenType.ingredients))
        menuItems.append(MenuItem(image: "menu-category.png", name: "Categories".localized, screenType:ScreenType.categories))
        menuItems.append(MenuItem(image: "menu-settings.png", name: "Settings".localized, screenType:ScreenType.settings))
        
        self.title = "RecipeBook".localized
    }

    func createViewController(forScreenType screenType: ScreenType) -> UIViewController? {
        switch screenType {
        case .recipes:
            return AppDelegate.shared?.appDependecies?.recipesWireframe?.getRecipesInterface()
        case .ingredients:
            return AppDelegate.shared?.appDependecies?.ingredientsWireframe?.getIngredientsInterface()
        case .categories:
            return AppDelegate.shared?.appDependecies?.categoriesWireframe?.getCategoriesInterface()
        case .settings:
            return AppDelegate.shared?.appDependecies?.settingsWireframe?.getSettingsInterface()
        }
    }
}

// MARK: UITableViewDelegate methods

extension MenuTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let targetViewController = self.createViewController(forScreenType: menuItems[indexPath.row].screenType)
        let navigationController = AppDelegate.shared?.appDependecies?.rootNavigationController

        let menuButton = UIButton(type: .custom)
        menuButton.setImage(UIImage(named: "menu-alt-24.png"), for: .normal)
        menuButton.frame = CGRect(x: 10, y: 0, width: 42, height: 42)
        menuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        targetViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        
        navigationController?.viewControllers = [targetViewController!]
        self.revealViewController().pushFrontViewController(navigationController, animated: true)
    }
    
    @objc func openMenu(_ sender: AnyObject) {
        self.revealViewController().revealToggle(nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView(frame: CGRect(x:0,y: 0,width: tableView.frame.size.width,height: 1))
        footerView.backgroundColor = UIColor.white
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
}

// MARK: UITableViewDataSource methods

extension MenuTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as UITableViewCell
        cell.imageView?.image = UIImage.init(named: menuItems[indexPath.row].image)
        cell.textLabel?.text = menuItems[indexPath.row].name
        
        return cell
    }
    
}
