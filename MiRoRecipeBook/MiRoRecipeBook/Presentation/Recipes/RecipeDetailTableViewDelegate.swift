//
//  IngredientsAndStepsTableViewDelegate.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 15.12.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation

class RecipeDetailHeaderView: UITableViewCell {
    
    @IBOutlet weak public var titleLabel: UILabel!
    @IBOutlet weak public var descLabel: UILabel!
    @IBOutlet weak public var durationLabel: UILabel!
    @IBOutlet weak public var portionsLabel: UILabel!
    
    @IBOutlet weak public var sectionLabel: UILabel!
}

class RecipeDetailTableViewDelegate: NSObject, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x:0,y: 0,width: tableView.frame.size.width,height: 1))
        footerView.backgroundColor = ColorPalette.gray25
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        // This is where you would change section header content
        let headerView = tableView.dequeueReusableCell(withIdentifier: "header") as? RecipeDetailHeaderView
        
        if section == 1 {
            headerView?.titleLabel?.isHidden = true
            headerView?.descLabel?.isHidden = true
            headerView?.portionsLabel?.isHidden = true
            headerView?.durationLabel?.isHidden = true
            headerView?.sectionLabel?.text = "steps".localized
        } else {
        
            let ds = tableView.dataSource as! RecipeDetailTableViewDatasource?
            let recipe = ds?.recipe
            
            headerView?.titleLabel?.text = recipe?.name
            
            var subText = ""
            if let teaser = recipe?.teaser {
                subText = teaser
            }
            if let desc = recipe?.desc {
                subText += desc
            }
            
            headerView?.descLabel?.text = subText
            
            headerView?.portionsLabel?.text = "portions".localized + ": \((recipe?.portions)!)"
            headerView?.durationLabel?.text = "duration".localized + ": \((recipe?.time)!) " + "min".localized
            
            headerView?.sectionLabel?.text = "ingredients".localized
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 60
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 120
        }
        
        return 40.0
    }
}
