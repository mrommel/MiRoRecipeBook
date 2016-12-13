//
//  IngredientRecipesDetailViewController.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 13.12.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

class IngredientRecipesDetailViewController: UITableViewController {
    
    let recipeManager = RecipeManager()
    var ingredientIdentifier: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "IngredientRecipes"
        
        let recipes = recipeManager.getRecipes(forIngredient: ingredientIdentifier!)
        NSLog("recipes: %d", recipes!.count)
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

extension IngredientRecipesDetailViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
        let recipe = self.getRecipe(withIndex: indexPath.row)
        AppDelegate.shared?.appDependecies?.recipesWireframe?.presentDetail(forRecipe:recipe)
    }
    
    func getRecipe(withIndex index: Int) -> Recipe {
        
        let recipeItems = recipeManager.allRecipes()
        
        return recipeItems![index]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x:0,y: 0,width: tableView.frame.size.width,height: 12))
        footerView.backgroundColor = ColorPalette.gray25
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x:0,y: 0,width: tableView.frame.size.width,height: 12))
        footerView.backgroundColor = ColorPalette.gray25
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12.0
    }
    
}

// MARK: UITableViewDataSource methods

extension IngredientRecipesDetailViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeManager.allRecipes()!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as UITableViewCell
        
        let recipe = self.getRecipe(withIndex: indexPath.row)
        cell.textLabel?.text = recipe.name
        cell.detailTextLabel?.text = recipe.desc
        
        cell.imageView?.setImage(withUrl: recipe.getImageUrl()!, placeholder: UIImage(named: "recipe-default-image.png"), crossFadePlaceholder: false, cacheScaled: false, completion: { imageInstance, error in
            
            cell.imageView?.image = self.resizeImage(image: imageInstance!.image!, toTheSize: CGSize.init(width: 40, height: 40))
            cell.imageView?.layer.cornerRadius = 20
            cell.imageView?.clipsToBounds = true
        })
        
        return cell
    }
    
}
