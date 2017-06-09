//
//  NetworkRequestManager.swift
//  PhotoRama-Ch20
//
//  Created by Ben Smith on 30/05/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import Foundation

typealias responseDictionary = [String : AnyObject]
typealias APIMovieResponse = (_ inner: (responseDictionary?, NSError?) throws -> Void) -> ()

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
                    let errorResponseObject = ErrorResponse.init(nsError: requestError as NSError)
                    
                    onCompletion({responseDict,error in
                        throw error!
                    })
//                    onCompletion(nil, errorResponseObject?.standardNSError)
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
                    passBackOMDBErrorResponse(errorResponseObject, onCompletion)
                }
                else {
                    parseResultsFrom(from: jsonDictionary, onCompletion: onCompletion)
                }
            }

        } catch let error  {
            OperationQueue.main.addOperation {
                if let errorResponseObject = ErrorResponse.init(nsError: error as NSError) {
                    onCompletion({responseDict,error in
                        throw errorResponseObject.standardNSError!
                    })
                }
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
    
    private static func passBackOMDBErrorResponse(_ errorResponse: ErrorResponse, _ onCompletion: @escaping APIMovieResponse){
        OperationQueue.main.addOperation {
            onCompletion({inner,response in
                throw errorResponse.standardNSError!
            })
        }
    }
    
    private static func createMovieDetails(from jsonDictionary: NSDictionary, _ onCompletion: @escaping APIMovieResponse){
        if let movie = MovieDetail.init(dictionary: jsonDictionary) {
        
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
            onCompletion(["results" : searchObjectsArray as AnyObject], nil)
        }
    }
    
}
