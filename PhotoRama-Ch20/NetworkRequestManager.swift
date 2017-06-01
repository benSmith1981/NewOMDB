//
//  NetworkRequestManager.swift
//  PhotoRama-Ch20
//
//  Created by Ben Smith on 30/05/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import Foundation

typealias APIMovieResponse = (Bool, [Search]?, NSError?) -> Void

class  NetworkRequestManager {
    
    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    static func omdbRequest(with url: URL, onCompletion: @escaping APIMovieResponse) {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let jsonData = data {
                parseReceivedData(jsonData, onCompletion)
            } else if let requestError = error {
                onCompletion(false, nil, requestError as NSError)
            }
        }
        task.resume()
    }
    
    private static func parseReceivedData(_ jsonData: Data, _ onCompletion: @escaping APIMovieResponse) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as AnyObject?
            if let arrayOfSearchResults = jsonObject?["Search"] as? NSArray {
                iterateArrayOf(searchResults: arrayOfSearchResults, onCompletion)
            }
        } catch let error  {
            print(error)
            onCompletion(false, nil, error as NSError)

        }
    }
    
    private static func iterateArrayOf(searchResults: NSArray, _ onCompletion: @escaping APIMovieResponse) {
        var temp: [Search] = []
        for searchResult in searchResults{
            if let searchResult = searchResult as? [String: AnyObject] {
                //parse and store json response
                let search = Search.init(dictionary: searchResult as NSDictionary)
                temp.append(search!)
            }
        }
        onCompletion(true, temp, nil)
    }
    
}
