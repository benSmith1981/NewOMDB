//
//  FlickrAPI.swift
//  PhotoRama-Ch20
//
//  Created by Ben Smith on 30/05/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import Foundation

enum SearchTerm {
    case byTitle(String)
    case byImdbID(String)
}

struct omdbURLCreator {
    static let apiKeyOMDB = "3b0c7c0c"
    static let baseURLString = "https://www.omdbapi.com/"

    private static func searchQuery(by term: SearchTerm) -> URLQueryItem {
        switch term {
        case .byTitle(let title):
            //e.g. https://www.omdbapi.com/?apikey=3b0c7c0c&scheme=https&path=&host=svr2.omdbapi.com&s=Jaws&page=1
            return URLQueryItem(name: "s", value: title)
        case .byImdbID(let imdbID):
            //e.g. https://www.omdbapi.com/?apikey=3b0c7c0c&scheme=https&path=&host=svr2.omdbapi.com&i=tt0073195
            return URLQueryItem(name: "i", value: imdbID)
        }
    }
    
    private static func plotLength(by term: SearchTerm) -> URLQueryItem? {
        switch term {
        case .byImdbID:
            //e.g. https://www.omdbapi.com/?apikey=3b0c7c0c&scheme=https&path=&host=svr2.omdbapi.com&i=tt0073195&page=1&plot=full
            return URLQueryItem(name: "plot", value: "full")
        default:
            return nil
        }
    }
    
    private static func pageNumber(by term: SearchTerm, page: Int = 1) -> URLQueryItem? {
        switch term {
        case .byTitle:
            //e.g. https://www.omdbapi.com/?apikey=3b0c7c0c&scheme=https&path=&host=svr2.omdbapi.com&s=Jaws&page=1
            return URLQueryItem(name: "page", value: "\(page)")
        default:
            return nil
        }
    }
    
    static func createOMDBURLWithComponents(term: SearchTerm, page: Int = 1) -> URL? {
        var urlcomps = URLComponents(string: omdbURLCreator.baseURLString)!
        var queryItems = [URLQueryItem]()
        
        //common parameters
        //e.g. https://www.omdbapi.com/?apikey=3b0c7c0c&scheme=https&path=&host=svr2.omdbapi.com&i=tt0073195&page=1&plot=full
        let baseParams = ["scheme" : "https",
                          "host" : "svr2.omdbapi.com",
                          "path" : "",
                          "apikey" : omdbURLCreator.apiKeyOMDB]
        //append your query items to queryItems itereating common base params
        for (key, value) in  baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        //additional parameters...
        //this returns
        let searchQuery = omdbURLCreator.searchQuery(by: term)
        queryItems.append(searchQuery)
        
        if let plotQuery = omdbURLCreator.plotLength(by: term) {
            queryItems.append(plotQuery)
        }
        
        if let pageNumberQuery = omdbURLCreator.pageNumber(by: term, page: page) {
            queryItems.append(pageNumberQuery)
        }

        
        //now set all the query itesm to our url componen
        urlcomps.queryItems = queryItems
        
        return urlcomps.url!
    }
    
    static func getApiKey() {
        //add on api key URLQueryItem
        //install:      pod 'KeychainSwift', '~> 8.0'
//        let keychain = KeychainSwift()
//        let key = keychain.get(OMDBConstants.keyChainKeys.apiKey)
    }
    
}



//API key: 7cbc11a0b9a67da78fcbefb01d79772b
// secere c599f4e8ed12ebdb

enum Method: String {
    case interestingPhotos = "flickr.interestingness.getList"
}

struct FlickrAPI {
    static let apiKeyFlickr = "7cbc11a0b9a67da78fcbefb01d79772b"
    static let baseURLString = "https://www.omdbapi.com/"

    static var interestingPhotos: URL {
        return flickrURL(method: .interestingPhotos, parameters: ["s": "jaws"])
    }
    
    static func flickrURL(method: Method, parameters: [String:String]?) -> URL {
        
        var urlcomps = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        //common parameters
        let baseParams = ["scheme" : "https",
                          "host" : "svr2.omdbapi.com",
                          "path" : "",
                          "apikey" : FlickrAPI.apiKeyFlickr]
        //append your query
        for (key, value) in  baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        //add additional params to url
        //itereates the dict of parameters
        if let additionalParams = parameters {
            for(key, value) in additionalParams{
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        urlcomps.queryItems = queryItems
        return urlcomps.url!
    }
}
