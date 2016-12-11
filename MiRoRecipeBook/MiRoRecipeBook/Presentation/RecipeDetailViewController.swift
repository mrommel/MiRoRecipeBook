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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup scrollview
        let insets = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        
        if recipe != nil {
            NSLog("recipe: %@", recipe ?? "<default>")
            self.navigationController?.title = recipe?.name
            //self.descLabel?.text = (recipe!.teaser)! + " " + (recipe!.desc)!;
            //self.imageLabel?.setImage(withUrl: recipe!.getImageUrl()!, placeholder: UIImage(named: "recipe-default-image.png"))
            
            addEntry(sender: self)
        }
    }
    
    @IBAction func addEntry(sender: AnyObject) {
        
        let stack = stackView
        var index = (stack?.arrangedSubviews.count)! - 1
        
        var h: CGFloat = 0.0
        if index != -1 {
            let addView = stack?.arrangedSubviews[index]
            h = (addView?.frame.size.height)!
        } else {
            index = 0
        }
        
        
        let scroll = scrollView
        let offset = CGPoint(x: (scroll?.contentOffset.x)!,
                             y: (scroll?.contentOffset.y)! + h)
        
        let newView = createEntry()
        newView.isHidden = true
        stack?.insertArrangedSubview(newView, at: index)
        
        UIView.animate(withDuration: 0.25) { () -> Void in
            newView.isHidden = false
            scroll?.contentOffset = offset
        }
    }
    
    @IBAction func goBackToList(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    private func createEntry() -> UIView {
        let date = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .short, timeStyle: .none)
        let number = "\(randomHexQuad())-\(randomHexQuad())-\(randomHexQuad())-\(randomHexQuad())"
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .firstBaseline
        stack.distribution = .fill
        stack.spacing = 8
        
        let dateLabel = UILabel()
        dateLabel.text = date
        dateLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        
        let numberLabel = UILabel()
        numberLabel.text = number
        numberLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        
        let deleteButton = UIButton(type: .roundedRect)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.addTarget(self, action: Selector("deleteStackView"), for: .touchUpInside)
        
        stack.addArrangedSubview(dateLabel)
        stack.addArrangedSubview(numberLabel)
        stack.addArrangedSubview(deleteButton)
        
        return stack
    }
    
    func deleteStackView(sender: UIButton) {
        /*if let view = sender.superview {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                view.hidden = true
            }, completion: { (success) -> Void in
                view.removeFromSuperview()
            })
        }*/
    }
    
    private func randomHexQuad() -> String {
        return NSString(format: "%X%X%X%X",
                        arc4random() % 16,
                        arc4random() % 16,
                        arc4random() % 16,
                        arc4random() % 16
            ) as String
    }

}
