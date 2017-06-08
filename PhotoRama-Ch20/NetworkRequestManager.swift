//
//  NetworkRequestManager.swift
//  PhotoRama-Ch20
//
//  Created by Ben Smith on 30/05/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import Foundation

typealias APIMovieResponse = (Bool, MovieDetail?, [Search]?, NSError?) -> Void

class NetworkRequestManager {

    static func omdbRequest(with url: URL, onCompletion: @escaping APIMovieResponse) {
        let config = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: config)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let jsonData = data {
                deserialiseReceivedData(jsonData, onCompletion)
            } else if let requestError = error {
                OperationQueue.main.addOperation {
                    onCompletion(false, nil, nil, requestError as NSError)
                }
            }
        }
        task.resume()
    }
    
    private static func deserialiseReceivedData(_ jsonData: Data, _ onCompletion: @escaping APIMovieResponse) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as AnyObject?
            
            if let jsonDictionary = jsonObject as? NSDictionary {
                let errorResponseObject = ErrorResponse.init(dictionary: jsonDictionary)!
                if isThereAnErrorInOMDBResponse(errorResponseObject) {
                    passBackErrorResponse(errorResponseObject, onCompletion)
                }
                else {
                    parseResultsFrom(from: jsonDictionary, onCompletion: onCompletion)
                }
            }

        } catch let error  {
            OperationQueue.main.addOperation {
                onCompletion(false, nil, nil, error as NSError)
            }

        }
    }
    
    private static func isThereAnErrorInOMDBResponse(_ errorResponse: ErrorResponse) -> Bool {
        return (errorResponse.response == false)
    }
    
    private static func parseResultsFrom(from jsonDict: NSDictionary, onCompletion: @escaping APIMovieResponse) {
        //have a plot then we know movie detail response
        if let _ = jsonDict["Plot"] as? String,
            let movieDetailDict = jsonDict as? NSDictionary{
            createMovieDetails(from: movieDetailDict, onCompletion)
        }
        
        if let arrayOfSearchResults = jsonDict["Search"] as? NSArray {
            createSearchObjects(from: arrayOfSearchResults, onCompletion)
        }
    }
    
    private static func passBackErrorResponse(_ errorResponse: ErrorResponse, _ onCompletion: @escaping APIMovieResponse){
        OperationQueue.main.addOperation {
            onCompletion(false, nil, nil, NSError.init(domain: "OMDB Domain", code: -1, userInfo: ["errorResponse" : errorResponse]))
        }
    }
    
    private static func createMovieDetails(from jsonDictionary: NSDictionary, _ onCompletion: @escaping APIMovieResponse){
        let movie = MovieDetail.init(dictionary: jsonDictionary)
        OperationQueue.main.addOperation {
            onCompletion(true, movie, nil, nil)
        }
    }
    
    private static func createSearchObjects(from jsonArray: NSArray, _ onCompletion: @escaping APIMovieResponse) {
        var searchObjectsArray: [Search] = []
        for searchResult in jsonArray{
            if let searchResult = searchResult as? [String: AnyObject] {
                //parse and store json response
                let search = Search.init(dictionary: searchResult as NSDictionary)
                searchObjectsArray.append(search!)
            }
        }
        OperationQueue.main.addOperation {
            onCompletion(true, nil, searchObjectsArray, nil)
        }
    }
    
}
