//
//  RecipeDetailViewController.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 27.11.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import UIKit
import MapleBacon

class RecipeDetailViewController: UIViewController {
    
    var recipe: Recipe?

    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var stackView: UIStackView!
    
    @IBOutlet weak private var imageLabel: UIImageView!
    
    @IBOutlet weak private var ingredientTableView: UITableView!
    var recipeDetailTableViewDelegate: RecipeDetailTableViewDelegate?
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
            self.ingredientTableView.estimatedRowHeight = 400.0
            self.ingredientTableView.rowHeight = UITableViewAutomaticDimension
            
            self.recipeDetailTableViewDelegate = RecipeDetailTableViewDelegate.init()
            self.ingredientTableView.delegate = self.recipeDetailTableViewDelegate
            
            self.recipeDetailTableViewDatasource = RecipeDetailTableViewDatasource.init(forRecipe: recipe)
            self.ingredientTableView.dataSource = recipeDetailTableViewDatasource
            
            self.categoryTableViewDatasource = CategoryTableViewDatasource.init(forRecipe: recipe)
            self.categoryTableView.dataSource = self.categoryTableViewDatasource
            
            self.categoryTableViewDelegate = CategoryTableViewDelegate.init()
            self.categoryTableView.delegate = self.categoryTableViewDelegate
        }
    }

}
