//
//  CategoriesWireframe.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 18.12.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

class CategoriesWireframe: CommonWireframe {
    
    fileprivate let kCategoriesStoryboardName = "Categories"
    
    override init(withRootNavigationController navigationController: UINavigationController?) {
        super.init(withRootNavigationController: navigationController)
    }
    
    func getCategoriesInterface() -> CategoriesTableViewController {
        let categoriesTableViewController = CategoriesTableViewController.instantiate(fromStoryboard: kCategoriesStoryboardName)
        
        return categoriesTableViewController
    }
    
}
