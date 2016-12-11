//
//  ColorPalette.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 23.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation

class ColorPalette: NSObject {
 
    open class var green: UIColor { get { return UIColor(red: 67.0/255.0, green: 184.0/255.0, blue: 115.0/255.0, alpha: 1.0) } }
    
    open class var gray25: UIColor { get { return UIColor(red: 225.0 / 255.0, green: 225.0 / 255.0, blue: 225.0 / 255.0, alpha: 1.0) } }
    
    open class var themeColor: UIColor { get { return green } }
    
    open class var tintColor: UIColor { get { return UIColor.white } }
}

class FontPalette: NSObject {
    
    struct FontPaletteName {
        static let FontNameArial = "Arial"
    }
    
    struct FontPaletteSize {
        static let FontSizeTiny: CGFloat = 13
        static let FontSizeSmall: CGFloat = 14
        static let FontSizeDefault: CGFloat = 16
        static let FontSizeLarge: CGFloat = 20
        static let FontSizeExtraLarge: CGFloat = 24
        static let FontSizeGiant: CGFloat = 36
    }
    
    class func navBarTitleFont() -> UIKit.UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: FontPaletteSize.FontSizeDefault, weight: UIFontWeightMedium)
        } else {
            return UIFont.systemFont(ofSize: FontPaletteSize.FontSizeDefault)
        }
    }
    
    class func navBarButtonFont() -> UIKit.UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: FontPaletteSize.FontSizeDefault, weight: UIFontWeightRegular)
        } else {
            return UIFont.systemFont(ofSize: FontPaletteSize.FontSizeDefault)
        }
    }
    
    class func subtitleFont() -> UIKit.UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: FontPaletteSize.FontSizeDefault, weight: UIFontWeightRegular)
        } else {
            return UIFont.systemFont(ofSize: FontPaletteSize.FontSizeDefault)
        }
    }
}
