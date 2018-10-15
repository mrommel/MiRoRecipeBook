//
//  SettingsTableViewController.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 23.11.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import UIKit
import SwiftSpinner
import MapleBacon
import SideMenu

class SettingsTableViewController: UITableViewController {
    
    var menuItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Settings"
        
        self.menuItems.append("Sync")
        self.menuItems.append("Reset")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as UITableViewCell
        
        if indexPath.row == 0 {
            cell.imageView?.image = UIImage.init(named: "download.png")
        } else {
            cell.imageView?.image = UIImage.init(named: "reset.png")
        }
        cell.textLabel?.text = self.menuItems[indexPath.row]
        
        return cell
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            SwiftSpinner.show("Connecting to server ...")
            SwiftSpinner.show(delay: 2, title: "... restarting the Internet")
            DispatchQueue.global(qos: .background).async {
                let recipeManager = RecipeManager()
                recipeManager.importData(successBlock: { 
                    DispatchQueue.main.async {
                        SwiftSpinner.hide()
                        self.tableView.deselectRow(at: indexPath, animated: true)
                        self.showSyncAlertSuccess()
                    }
                }, onError: { (error) in
                    DispatchQueue.main.async {
                        SwiftSpinner.hide()
                        self.tableView.deselectRow(at: indexPath, animated: true)
                        self.showSyncAlert(forError: error!)
                    }
                })
            }
            break;
        case 1:
            SwiftSpinner.show("reseting ...")
            DispatchQueue.global(qos: .background).async {

				Cache.default.clearMemory()
                
                let recipeManager = RecipeManager()
                recipeManager.clearData(successBlock: {
                    DispatchQueue.main.async {
                        SwiftSpinner.hide()
                        self.tableView.deselectRow(at: indexPath, animated: true)
                    }
                })
            }
            break;
        default:
            break;
        }
    }
    
    func showSyncAlertSuccess() {
        let alert = UIAlertController(title: "Success".localized, message: "You can use the data now", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSyncAlert(forError error: Error) {
        
        var errorMsg = ""
		switch error {
		case RestApiManagerError.serverDown:
			errorMsg = "server not started yet".localized
        default:
			errorMsg = "generic error".localized + ": \(error._code)"
        }
        
        let alert = UIAlertController(title: "Error".localized, message: errorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func openMenu(_ sender: AnyObject) {
		self.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
}
