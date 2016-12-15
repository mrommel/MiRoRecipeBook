//
//  RecipeDetailViewController.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 27.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import UIKit
import MapleBacon

class IngredientsAndStepsTableViewDelegate: NSObject, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x:0,y: 0,width: tableView.frame.size.width,height: 1))
        footerView.backgroundColor = ColorPalette.gray25
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3.0
    }
}

class IngredientsAndStepsTableViewDataSource: NSObject, UITableViewDataSource {

    let recipeManager = RecipeManager()
    var steps: [RecipeStep]?
    var ingredients: [RecipeIngredient]?
    
    init(forSteps steps: [RecipeStep]?, ingredients: [RecipeIngredient]?) {
        super.init()
        
        self.steps = steps
        self.ingredients = ingredients
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.ingredients!.count
        } else {
            return self.steps!.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "ingredients".localized
        } else {
            return "steps".localized
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func getRecipeIngredient(withIndex index: Int) -> RecipeIngredient {
        return self.ingredients![index]
    }
    
    func getRecipeStep(withIndex index: Int) -> String {
        return self.steps![index].step!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! RecipeTableViewCell
        
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            let recipeIngredient = self.getRecipeIngredient(withIndex: indexPath.row)
            let ingredient = recipeManager.getIngredient(withIdentifier: recipeIngredient.ingredient_identifier)
            cell.recipeTitleLabel?.text = ingredient?.name
            cell.recipeDescriptionLabel?.text = recipeIngredient.quantity
            
            if ingredient?.getImageUrl() != nil {
                cell.imageView?.setImage(withUrl: (ingredient?.getImageUrl())!, placeholder: UIImage(named: "recipe-default-image.png"), crossFadePlaceholder: false, cacheScaled: false)
            }
        } else {
            let step = self.getRecipeStep(withIndex: indexPath.row)

            cell.recipeTitleLabel?.text = step
            cell.recipeDescriptionLabel?.text = ""
        
            /*if ingredient?.getImageUrl() != nil {
            cell.imageView?.setImage(withUrl: (ingredient?.getImageUrl())!, placeholder: UIImage(named: "recipe-default-image.png"), crossFadePlaceholder: false, cacheScaled: false)
             }*/
        }
        
        return cell
    }
}

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
