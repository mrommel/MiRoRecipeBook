//
//  IntegrientsTableViewController.swift
//  MiRo.RecipeBook
//
//  Created by Michael Rommel on 22.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import UIKit

class IntegrientsTableViewController: UITableViewController {
    
    let recipeManager = RecipeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Integrients"
        
        let integrients = recipeManager.allIntegrients()
        NSLog("recipes: %d", integrients!.count)
        
        self.tableView.contentInset = UIEdgeInsets.init(top: 60, left: 0, bottom: 0, right: 0)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeManager.allIntegrients()!.count
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
        
        let integrient = self.getIntegrient(withIndex: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "integrientsCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = integrient.name
        
        let imageUrl = integrient.getImageUrl()!
        cell.imageView?.setImage(withUrl: imageUrl, placeholder: UIImage(named: "recipe-default-image.png"), crossFadePlaceholder: false, cacheScaled: false, completion: { imageInstance, error in
            
            if error != nil {
                cell.imageView?.image = self.resizeImage(image: imageInstance!.image!, toTheSize: CGSize.init(width: 40, height: 40))
                cell.imageView?.layer.cornerRadius = 20
                cell.imageView?.clipsToBounds = true
            }
        })
        
        return cell
    }
    
    func getIntegrient(withIndex index: Int) -> Integrient {
        
        let integrientItems = recipeManager.allIntegrients()
        
        return integrientItems![index]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            break;
        default:
            break;
        }
    }
    
    @IBAction func openMenu(_ sender: AnyObject) {
        self.revealViewController().revealToggle(nil)
    }
}
