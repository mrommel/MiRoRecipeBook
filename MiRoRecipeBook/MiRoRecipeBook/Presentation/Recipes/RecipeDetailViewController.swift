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
				self.imageLabel?.setImage(with: (recipe?.getImageUrl())!, placeholder: UIImage(named: "recipe-default-image.png"))
            }
            
            self.countryLabel?.text = recipe?.country
            if recipe?.getFlagUrl() != nil {
				self.flagLabel?.setImage(with: (recipe?.getFlagUrl())!)
            }
 
            self.ingredientTableView.allowsSelection = false
            self.ingredientTableView.estimatedRowHeight = 400.0
            self.ingredientTableView.rowHeight = UITableView.automaticDimension
            
            self.recipeDetailTableViewDelegate = RecipeDetailTableViewDelegate.init()
            self.ingredientTableView.delegate = self.recipeDetailTableViewDelegate
            
            self.recipeDetailTableViewDatasource = RecipeDetailTableViewDatasource.init(forRecipe: recipe, scale: 1)
            self.ingredientTableView.dataSource = recipeDetailTableViewDatasource
            
            self.categoryTableViewDatasource = CategoryTableViewDatasource.init(forRecipe: recipe)
            self.categoryTableView.dataSource = self.categoryTableViewDatasource
            
            self.categoryTableViewDelegate = CategoryTableViewDelegate.init()
            self.categoryTableView.delegate = self.categoryTableViewDelegate
            
        }
    }

    @IBAction func composeTapped(sender: UIBarButtonItem) {
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Recalculate the ingredients".localized, preferredStyle: .actionSheet)
        
        // 2
        let halfAction = UIAlertAction(title: "½x", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            NSLog("½x")
            
            self.recipeDetailTableViewDatasource?.scale = 0.5
            self.ingredientTableView.reloadData()
        })
        
        let normalAction = UIAlertAction(title: "1x", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            NSLog("1x")
            
            self.recipeDetailTableViewDatasource?.scale = 1.0
            self.ingredientTableView.reloadData()
        })
        let doubleAction = UIAlertAction(title: "2x", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            NSLog("2x")
            
            self.recipeDetailTableViewDatasource?.scale = 2.0
            self.ingredientTableView.reloadData()
        })
        let tripleAction = UIAlertAction(title: "3x", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            NSLog("3x")
            
            self.recipeDetailTableViewDatasource?.scale = 3.0
            self.ingredientTableView.reloadData()
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: {
            (action: UIAlertAction!) -> Void in
            NSLog("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(halfAction)
        optionMenu.addAction(normalAction)
        optionMenu.addAction(doubleAction)
        optionMenu.addAction(tripleAction)
        optionMenu.addAction(cancelAction)
        
        if let popoverPresentationController = optionMenu.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect.init(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        }
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
}
