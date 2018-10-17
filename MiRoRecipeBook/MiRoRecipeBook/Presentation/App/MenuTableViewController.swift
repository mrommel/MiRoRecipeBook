//
//  MenuTableViewController.swift
//  MiRo.RecipeBook
//
//  Created by Michael Rommel on 22.11.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import UIKit
import SideMenu

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

	var appWireframe: AppWireframe?
    
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

		self.appWireframe?.showDetail(for: targetViewController)
    }

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

		let headerView = UIImageView(frame: CGRect(x:0, y: 0,width: tableView.frame.size.width, height: 180))
		headerView.backgroundColor = UIColor.white
		headerView.image = UIImage(named: "Logo")
		headerView.contentMode = .scaleAspectFit

		return headerView
	}

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView(frame: CGRect(x:0,y: 0,width: tableView.frame.size.width,height: 1))
        footerView.backgroundColor = UIColor.white
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180.0
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
