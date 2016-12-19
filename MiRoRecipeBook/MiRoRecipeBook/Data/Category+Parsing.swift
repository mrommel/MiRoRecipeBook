//
//  Category+Parsing.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 19.12.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation

extension Category {

    class var kNoCategory: Int32 {
        return -1
    }
    
    func getImageUrl() -> URL? {
        
        if self.image_url == nil {
            return nil
        }
        
        var urlString = RestApiManager.baseURL + (self.image_url)!
        urlString = urlString.replacingOccurrences(of: "//", with: "/")
        let imageUrl = URL(string: urlString)
        return imageUrl
    }
}
