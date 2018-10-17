//
//  RecipeWebService.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 28.11.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias ServiceResponse = (JSON?, Error?) -> Void
typealias ErrorResponse = (Error?) -> Void

enum RestApiManagerError: Error {
	case unknownError
	case noContentError
	case serverDown
}

class RestApiManager: NSObject {
    
    static let sharedInstance = RestApiManager()
    
#if targetEnvironment(simulator)
    // simulator
    static let baseURL = "http://localhost:8023/"
#else
    // device
    static let baseURL = "http://192.168.52.44:8023/"
#endif
    
    func makeHTTPGetRequest(path: String, onCompletion: @escaping ServiceResponse) {
        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL)
        
        let session = URLSession.shared
        session.configuration.httpAdditionalHeaders?["Accept"] = "application/json; indent=4"
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in

			guard let httpResponse = response as? HTTPURLResponse else {
				onCompletion(nil, RestApiManagerError.unknownError)
				return
			}

			guard error == nil else {
				onCompletion(nil, RestApiManagerError.unknownError)
				return
			}

			if httpResponse.statusCode == 404 {
				onCompletion(nil, RestApiManagerError.serverDown)
				return
			}

			if httpResponse.statusCode == 200 {
				do {
                	let json: JSON = try JSON(data: data!)
					onCompletion(json, nil)
				} catch {
					onCompletion(nil, RestApiManagerError.noContentError)
				}
            } else {
                onCompletion(nil, RestApiManagerError.unknownError)
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
                
				if let results = json?.array {
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
                
				if let results = json?.array {
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
                
				if let results = json?.array {
                    for entry in results {
                        categoryJSONs.append(entry)
                    }
                }
                
                onCompletion(categoryJSONs as [JSON]?)
            }
        })
    }

}
