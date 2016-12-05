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
    
    @IBOutlet weak var descLabel: UILabel?
    @IBOutlet weak var imageLabel: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if recipe != nil {
            NSLog("recipe: %@", recipe ?? "<default>")
            self.title = recipe?.name
            self.descLabel?.text = (recipe!.teaser)! + " " + (recipe!.desc)!;
            self.imageLabel?.setImage(withUrl: recipe!.getImageUrl()!, placeholder: UIImage(named: "recipe-default-image.png"))
        }
    }
    
    @IBAction func goBackToList(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}

