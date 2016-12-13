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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup scrollview
        let insets = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        
        if recipe != nil {
            NSLog("recipe: %@", recipe ?? "<default>")
            self.title = recipe?.name
            self.titleLabel?.text = recipe?.name
            self.descLabel?.text = (recipe!.teaser)! + " " + (recipe!.desc)!;
            self.imageLabel?.setImage(withUrl: recipe!.getImageUrl()!, placeholder: UIImage(named: "recipe-default-image.png"))
        }
    }
}
