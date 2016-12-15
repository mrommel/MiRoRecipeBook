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
    
    var ingredientTableView: UITableView!
    
    var stepsTableViewDelegate: IngredientsAndStepsTableViewDelegate?
    var recipeDetailTableViewDatasource: RecipeDetailTableViewDatasource?

    override func viewDidLoad() {
        super.viewDidLoad()

        if recipe != nil {
            NSLog("recipe: %@", recipe ?? "<default>")
            self.title = recipe?.name
            
            if recipe?.getImageUrl() != nil {
                self.imageLabel?.setImage(withUrl: (recipe?.getImageUrl())!, placeholder: UIImage(named: "recipe-default-image.png"))
            }
 
            self.ingredientTableView.allowsSelection = false
            
            self.stepsTableViewDelegate = IngredientsAndStepsTableViewDelegate.init()
            self.ingredientTableView.delegate = stepsTableViewDelegate
            
            self.recipeDetailTableViewDatasource = RecipeDetailTableViewDatasource.init(forRecipe: recipe)
            self.ingredientTableView.dataSource = recipeDetailTableViewDatasource
        }
    }

}
