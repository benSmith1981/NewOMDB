//
//  NetworkRequestManager.swift
//  PhotoRama-Ch20
//
//  Created by Ben Smith on 30/05/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import Foundation

typealias responseDictionary = [String : AnyObject]
typealias APIMovieResponse = (_ inner:(responseDictionary?) throws -> responseDictionary) -> Void
//                              (_ inner: () throws -> NSDictionary) -> Void
class NetworkRequestManager {
    
    func login3(params:[String: String], completion: (_ inner: () throws -> Void) -> ()) {
    }

    static func omdbRequest(with url: URL, onCompletion: @escaping APIMovieResponse) throws {
        let config = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: config)
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let jsonData = data {
                deserialiseReceivedData(jsonData, onCompletion)
            } else if let requestError = error {
                let errorResponseObject = ErrorResponse.init(nsError: requestError as NSError)
                
                onCompletion({response in
                    throw (errorResponseObject?.standardNSError!)!
                })
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
            if let errorResponseObject = ErrorResponse.init(nsError: error as NSError) {
                onCompletion({responseDict in
                    throw errorResponseObject.standardNSError!
                })
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
        onCompletion({responseDict in
            throw errorResponse.standardNSError!
        })
    }
    
    private static func createMovieDetails(from jsonDictionary: NSDictionary, _ onCompletion: @escaping APIMovieResponse){
        if let movie = MovieDetail.init(dictionary: jsonDictionary) {
            onCompletion({responseDict in
                return ["results" : movie]
            })
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
        onCompletion({responseDict in
            return ["results" : searchObjectsArray as AnyObject]
        })
        
    }
    //https://appventure.me/2015/06/19/swift-try-catch-asynchronous-closures/
//    func asynchronousWork(completion: @escaping (_ inner: () throws -> NSDictionary) -> Void) -> Void {
//        let config = URLSessionConfiguration.default
//        let session: URLSession = URLSession(configuration: config)
//        let request = URLRequest(url: NSURL.init(string: "") as! URL)
//        
//        let task = session.dataTask(with: request) { (data, response, error) in
//            
//            completion({return [:]})
//            
//            completion({throw error!})
//        }
//    }
}
