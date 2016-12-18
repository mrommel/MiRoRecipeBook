//
//  RecipeWebService.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 28.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias ServiceResponse = (JSON, NSError?) -> Void
typealias ErrorResponse = (NSError?) -> Void

class RestApiManager: NSObject {
    
    static let sharedInstance = RestApiManager()
    
#if TARGET_IPHONE_SIMULATOR
    static let baseURL = "http://localhost:8000/"
#else
    static let baseURL = "http://192.168.178.20:8000/"
#endif
    
    func makeHTTPGetRequest(path: String, onCompletion: @escaping ServiceResponse) {
        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL)
        
        let session = URLSession.shared
        session.configuration.httpAdditionalHeaders?["Accept"] = "application/json; indent=4"
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            
            if error == nil {
                let json:JSON = JSON(data: data!)
                onCompletion(json, error as NSError?)
            } else {
                onCompletion(nil, error as NSError?)
            }
        })
        task.resume()
    }
}

class RecipeWebService: RestApiManager {
    
    func getAllRecipeJSONs(onCompletion: @escaping ([JSON]?) -> Void, onError errorBlock: ErrorResponse?) {
        let route = RestApiManager.baseURL + "recipes/"
        makeHTTPGetRequest(path: route, onCompletion: { json, err in
            
            if err != nil {
                guard errorBlock != nil else {
                    return
                }
                errorBlock!(err)
            } else {
                var recipeJSONs: [JSON] = []
                
                if let results = json.array {
                    for entry in results {
                        recipeJSONs.append(entry)
                    }
                }
                
                onCompletion(recipeJSONs as [JSON]?)
            }
        })
    }
    
    func getAllIngredientJSONs(onCompletion: @escaping ([JSON]?) -> Void, onError errorBlock: ErrorResponse?) {
        let route = RestApiManager.baseURL + "ingredients/"
        makeHTTPGetRequest(path: route, onCompletion: { json, err in
            if err != nil {
                guard errorBlock != nil else {
                    return
                }
                errorBlock!(err)
            } else {
                var ingredientJSONs: [JSON] = []
                
                if let results = json.array {
                    for entry in results {
                        ingredientJSONs.append(entry)
                    }
                }
                
                onCompletion(ingredientJSONs as [JSON]?)
            }
        })
    }
    
    func getAllCategoryJSONs(onCompletion: @escaping ([JSON]?) -> Void, onError errorBlock: ErrorResponse?) {
        let route = RestApiManager.baseURL + "categories/"
        makeHTTPGetRequest(path: route, onCompletion: { json, err in
            if err != nil {
                guard errorBlock != nil else {
                    return
                }
                errorBlock!(err)
            } else {
                var categoryJSONs: [JSON] = []
                
                if let results = json.array {
                    for entry in results {
                        categoryJSONs.append(entry)
                    }
                }
                
                onCompletion(categoryJSONs as [JSON]?)
            }
        })
    }

}
