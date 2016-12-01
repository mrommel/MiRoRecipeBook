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

class RestApiManager: NSObject {
    
    static let sharedInstance = RestApiManager()
    
    static let baseURL = "http://localhost:8000/"
    
    func makeHTTPGetRequest(path: String, onCompletion: @escaping ServiceResponse) {
        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL)
        
        let session = URLSession.shared
        session.configuration.httpAdditionalHeaders?["Accept"] = "application/json; indent=4"
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            
            if error == nil {
                let json:JSON = JSON(data: data!)
                onCompletion(json, error as NSError?)
            }
        })
        task.resume()
    }
}

class RecipeWebService: RestApiManager {
    
    func getAllRecipeJSONs(onCompletion: @escaping ([JSON]?) -> Void) {
        let route = RestApiManager.baseURL + "recipes/"
        makeHTTPGetRequest(path: route, onCompletion: { json, err in
            
            var recipeJSONs: [JSON] = []
            
            if let results = json.array {
                for entry in results {
                    recipeJSONs.append(entry)
                }
            }
            
            onCompletion(recipeJSONs as [JSON]?)
        })
    }
    
    /*
     func makeHTTPPostRequest(path: String, body: [String: AnyObject], onCompletion: ServiceResponse) {
     var err: NSError?
     let request = NSMutableURLRequest(URL: NSURL(string: path)!)
     
     // Set the method to POST
     request.HTTPMethod = "POST"
     
     // Set the POST body for the request
     request.HTTPBody = NSJSONSerialization.dataWithJSONObject(body, options: nil, error: &err)
     let session = NSURLSession.sharedSession()
     
     let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
     let json:JSON = JSON(data: data)
     onCompletion(json, err)
     })
     task.resume()
     }
    */
    
}
