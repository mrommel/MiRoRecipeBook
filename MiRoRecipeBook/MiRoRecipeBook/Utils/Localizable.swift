//
//  Localizable.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 13.12.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

extension NSString {
    var localized: NSString {
        return NSLocalizedString(self as String, tableName: nil, bundle: Bundle.main, value: "", comment: "") as NSString
    }
}
