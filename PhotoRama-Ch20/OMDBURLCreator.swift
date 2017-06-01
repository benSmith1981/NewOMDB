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
