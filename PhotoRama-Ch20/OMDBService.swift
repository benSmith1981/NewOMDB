//
//  OMDBService.swift
//  PhotoRama-Ch20
//
//  Created by Ben Smith on 30/05/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import Foundation

class OMDBService {
    
    static func searchMovieByTitle(title: String) {
        let url = omdbURLCreator.createOMDBURLWithComponents(term: .bySearch(title), page: 1)

        NetworkRequestManager.omdbRequest(with: url!) { (success, searchResultsArray, error) in
            if success {
                let searchResults = ["searchResults": searchResultsArray]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "searchResults"),
                                                object: self,
                                                userInfo: searchResults)
            }
        }
        
    }
}
