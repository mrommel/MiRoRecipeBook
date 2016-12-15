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
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descLabel: UILabel!
    @IBOutlet weak private var durationLabel: UILabel!
    @IBOutlet weak private var portionsLabel: UILabel!
    @IBOutlet weak private var ingredientTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if recipe != nil {
            NSLog("recipe: %@", recipe ?? "<default>")
            self.title = recipe?.name
            self.titleLabel?.text = recipe?.name
            
            var subText = ""
            if let teaser = recipe?.teaser {
                subText = teaser
            }
            if let desc = recipe?.desc {
                subText += desc
            }
            
            self.descLabel?.text = subText
            if recipe?.getImageUrl() != nil {
                self.imageLabel?.setImage(withUrl: (recipe?.getImageUrl())!, placeholder: UIImage(named: "recipe-default-image.png"))
            }
            
            self.portionsLabel?.text = "portions".localized + ": \((self.recipe?.portions)!)"
            self.durationLabel?.text = "duration".localized + ": \((self.recipe?.time)!) " + "min".localized
 
            self.ingredientTableView.allowsSelection = false
            let stepsTableViewDelegate = IngredientsAndStepsTableViewDelegate.init()
            self.ingredientTableView.delegate = stepsTableViewDelegate
            let stepsTableViewDatasource = IngredientsAndStepsTableViewDataSource.init(forSteps: recipe?.getSteps(), ingredients: recipe?.getRecipeIngredients())
            self.ingredientTableView.dataSource = stepsTableViewDatasource
        }
    }

}
