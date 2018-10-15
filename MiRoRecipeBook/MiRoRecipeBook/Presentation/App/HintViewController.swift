//
//  HintViewController.swift
//  MiRo.RecipeBook
//
//  Created by Michael Rommel on 22.11.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import UIKit
import SideMenu

class HintViewController: UIViewController {
    
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var exploreImage: UIImageView!

	var appWireframe: AppWireframe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "hint.title".localized
        self.hintLabel.text = "hint.message".localized
        
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseOut, animations: {
            // Here you will get the animation you want
            self.exploreImage.alpha = 1
        }, completion: { finished in
            // Here you hide it when animation done
            self.exploreImage.isHidden = false
        })
    }
    
    @IBAction func openMenu(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseOut, animations: {
            // Here you will get the animation you want
            self.exploreImage.alpha = 0
        }, completion: { finished in
            // Here you hide it when animation done
            self.exploreImage.isHidden = true
        })

		self.appWireframe?.showMenu()
    }
}
