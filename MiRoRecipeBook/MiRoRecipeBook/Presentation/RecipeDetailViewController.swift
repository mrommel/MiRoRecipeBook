//
//  RecipeDetailViewController.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 27.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import UIKit
import MapleBacon

class RecipeDetailViewController: UIViewController {
    
    var recipe: Recipe?

    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var stackView: UIStackView!
    
    @IBOutlet weak private var imageLabel: UIImageView!
    
    @IBOutlet weak private var ingredientTableView: UITableView!
    
    var stepsTableViewDelegate: IngredientsAndStepsTableViewDelegate?
    var recipeDetailTableViewDatasource: RecipeDetailTableViewDatasource?
    
    @IBOutlet weak public var countryLabel: UILabel!
    @IBOutlet weak private var flagLabel: UIImageView!
    
    @IBOutlet weak private var categoryTableView: UITableView!
    var categoryTableViewDatasource: CategoryTableViewDatasource?
    var categoryTableViewDelegate: CategoryTableViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        if recipe != nil {
            NSLog("recipe: %@", recipe ?? "<default>")
            self.title = recipe?.name
            
            if recipe?.getImageUrl() != nil {
                self.imageLabel?.setImage(withUrl: (recipe?.getImageUrl())!, placeholder: UIImage(named: "recipe-default-image.png"))
            }
            
            self.countryLabel?.text = recipe?.country
            if recipe?.getFlagUrl() != nil {
                self.flagLabel?.setImage(withUrl: (recipe?.getFlagUrl())!)
            }
 
            self.ingredientTableView.allowsSelection = false
            
            self.stepsTableViewDelegate = IngredientsAndStepsTableViewDelegate.init()
            self.ingredientTableView.delegate = self.stepsTableViewDelegate
            
            self.recipeDetailTableViewDatasource = RecipeDetailTableViewDatasource.init(forRecipe: recipe)
            self.ingredientTableView.dataSource = recipeDetailTableViewDatasource
            
            self.categoryTableViewDatasource = CategoryTableViewDatasource.init(forRecipe: recipe)
            self.categoryTableView.dataSource = self.categoryTableViewDatasource
            
            self.categoryTableViewDelegate = CategoryTableViewDelegate.init()
            self.categoryTableView.delegate = self.categoryTableViewDelegate
        }
    }

}

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak public var titleLabel: UILabel!
}

class CategoryTableViewDatasource: NSObject, UITableViewDataSource {
    
    let recipeManager = RecipeManager()
    var recipe: Recipe?
    var categories: [Category]?
    
    init(forRecipe recipe: Recipe?) {
        super.init()
        
        self.recipe = recipe
        self.categories = recipeManager.getCategories(withRecipeIdentifier: (self.recipe!.identifier))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categoryNumber = self.categories!.count
        return categoryNumber
    }
    
    func getRecipeCategory(withIndex index: Int) -> Category {
        return self.categories![index]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        
        cell.selectionStyle = .none
        
        let title = self.getRecipeCategory(withIndex: indexPath.row).name
        cell.textLabel?.text = title
        NSLog("title: \(title)")
        
        return cell
    }
}

class CategoryTableViewDelegate: NSObject, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x:0,y: 0,width: tableView.frame.size.width,height: 25))
        footerView.backgroundColor = ColorPalette.gray25
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x:0,y: 0,width: tableView.frame.size.width,height: 25))
        headerView.backgroundColor = ColorPalette.gray25

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 25.0
    }
}
