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
    
    let recipeManager = RecipeManager()
    var recipe: Recipe?
    var recipeIngredients: [RecipeIngredient]?
    
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var stackView: UIStackView!
    
    @IBOutlet weak private var imageLabel: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descLabel: UILabel!
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
            
            self.recipeIngredients = recipe?.getRecipeIngredients()
            self.ingredientTableView.delegate = self
            self.ingredientTableView.dataSource = self
        }
    }
    
    func resizeImage(image:UIImage, toTheSize size:CGSize) -> UIImage {
        
        let scale = CGFloat(max(size.width/image.size.width,
                                size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale;
        
        let rr:CGRect = CGRect.init(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.draw(in: rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage!
    }
}

// MARK: UITableViewDelegate methods

extension RecipeDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x:0,y: 0,width: tableView.frame.size.width,height: 1))
        footerView.backgroundColor = ColorPalette.gray25
        
        return footerView
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
        return 1.0
    }
}

// MARK: UITableViewDataSource methods

extension RecipeDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipeIngredients!.count
    }
    
    func getRecipeIngredient(withIndex index: Int) -> RecipeIngredient {
        return self.recipeIngredients![index]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell
        
        let recipeIngredient = self.getRecipeIngredient(withIndex: indexPath.row)
        let ingredient = recipeManager.getIngredient(withIdentifier: recipeIngredient.ingredient_identifier)
        cell.recipeTitleLabel?.text = ingredient?.name
        cell.recipeDescriptionLabel?.text = recipeIngredient.quantity
        
        if ingredient?.getImageUrl() != nil {
            cell.imageView?.setImage(withUrl: (ingredient?.getImageUrl())!, placeholder: UIImage(named: "recipe-default-image.png"), crossFadePlaceholder: false, cacheScaled: false)
        }
        
        return cell
    }
}
