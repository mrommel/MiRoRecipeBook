//
//  UIViewController+Storyboard.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 12.12.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class func instantiate(fromStoryboard name: String) -> Self {
        return instantiated(fromStoryboard: name, type: self)
    }
    
    fileprivate class func instantiated<T>(fromStoryboard name: String, type: T.Type) -> T {
        return UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: self.nameOfClass) as! T
    }
}

public extension NSObject {
    public class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    public var nameOfClass: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
}
