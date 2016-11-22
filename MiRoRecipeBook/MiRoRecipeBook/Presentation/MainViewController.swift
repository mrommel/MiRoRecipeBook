//
//  MainViewController.swift
//  MiRo.RecipeBook
//
//  Created by Michael Rommel on 22.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "test"
        
        // Do any additional setup after loading the view, typically from a nib.
        //menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openMenu(_ sender: AnyObject) {
        self.revealViewController().revealToggle(nil)
    }
}
