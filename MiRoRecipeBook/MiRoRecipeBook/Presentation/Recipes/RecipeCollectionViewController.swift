//
//  RecipeCollectionViewController.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 16.12.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import Foundation

class RecipeCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var imageView: UIImageView!
}

class RecipeCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var recipes: [Recipe]? = nil
    
    init(withRecipes recipes: [Recipe]?) {       
        self.recipes = recipes
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recipes!.count
    }
    
    func getRecipe(withIndex index: Int) -> Recipe {
        
        return self.recipes![index]
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for:indexPath) as! RecipeCollectionCell
        
        let recipe = self.getRecipe(withIndex: indexPath.row)
        
        if recipe.getImageUrl() != nil {
            cell.imageView?.setImage(withUrl: recipe.getImageUrl()!, placeholder: UIImage(named: "recipe-default-image.png"), crossFadePlaceholder: false, cacheScaled: false)
        }
        cell.caption.text = recipe.name!
        
        cell.backgroundView = UIImageView.init(image: UIImage.init(named: "photo-frame.png"))
        
        return cell
    }
}

class RecipeCollectionViewController: UICollectionViewController {
    
    let recipeManager = RecipeManager()
    var recipeDatasource: RecipeCollectionViewDataSource?
    var recipes: [Recipe]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Recipes".localized
        
        self.recipes = recipeManager.allRecipes()
        NSLog("recipes: %d", recipes!.count)
        
        self.recipeDatasource = RecipeCollectionViewDataSource.init(withRecipes: self.recipes)
        self.collectionView?.dataSource = self.recipeDatasource
        self.collectionView?.reloadData()
    }
    
}

// MARK:- UICollectionViewDelegate Methods

extension RecipeCollectionViewController {
    
    @available(iOS 6.0, *)
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let recipe = self.recipeDatasource?.getRecipe(withIndex: indexPath.row)
        AppDelegate.shared?.appDependecies?.recipesWireframe?.presentDetail(forRecipe:recipe)
    }

}
