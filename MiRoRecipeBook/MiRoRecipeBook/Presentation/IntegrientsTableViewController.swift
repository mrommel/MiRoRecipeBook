//
//  IngredientsTableViewController.swift
//  MiRo.RecipeBook
//
//  Created by Michael Rommel on 22.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import UIKit

class IngredientsTableViewController: UITableViewController {
    
    let recipeManager = RecipeManager()
    var ingredients: [Ingredient]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Ingredients".localized
        
        self.ingredients = recipeManager.allIngredients()
        NSLog("recipes: %d", self.ingredients!.count)
        
        self.tableView.contentInset = UIEdgeInsets.init(top: 60, left: 0, bottom: 0, right: 0)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ingredients!.count
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ingredient = self.getIngredient(withIndex: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientsCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = ingredient.name
        
        //let recipes = recipeManager.getRecipes(forIngredient: (ingredient.identifier?.intValue)!)
        //cell.detailTextLabel?.text = "\(recipes!.count) recipes"
        
        let imageUrl = ingredient.getImageUrl()!
        cell.imageView?.setImage(withUrl: imageUrl, placeholder: UIImage(named: "recipe-default-image.png"), crossFadePlaceholder: false, cacheScaled: false, completion: { imageInstance, error in
            
            if error != nil {
                cell.imageView?.image = self.resizeImage(image: imageInstance!.image!, toTheSize: CGSize.init(width: 40, height: 40))
                cell.imageView?.layer.cornerRadius = 20
                cell.imageView?.clipsToBounds = true
            }
        })
        
        return cell
    }
    
    func getIngredient(withIndex index: Int) -> Ingredient {
        
        return self.ingredients![index]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredient = self.getIngredient(withIndex: indexPath.row)
        AppDelegate.shared?.appDependecies?.ingredientsWireframe?.presentRecipes(forIngredientIdentifier: (ingredient.identifier?.intValue)!)
    }
}
