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
        do {
            try NetworkRequestManager.omdbRequest(with: url!) { (results, error) in
                NotificationCenter.default.post(name: Notification.Name(rawValue: "searchResults"),
                                                object: self,
                                                userInfo: results)
            }
        } catch {
            let errorResponseDict = ["error": error]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "omdbError"),
                                            object: self,
                                            userInfo: errorResponseDict)
        }

        
    }
    
    static func getMovieDetailsByID(ID: String) {
        let url = omdbURLCreator.createOMDBURLWithComponents(term: .byImdbIDFull(ID))
        
        do {
            try NetworkRequestManager.omdbRequest(with: url!) { (results, error) in
                do {
                    try CoredataManager.sharedInstance.persistentContainer.viewContext.save()
                } catch let error {
                    print(error.localizedDescription)
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: "movieDetailNotification"),
                                                object: self,
                                                userInfo: results)
            }

        } catch {
            let errorResponseDict = ["error": error]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "omdbError"),
                                            object: self,
                                            userInfo: errorResponseDict)
        }

        
    }
}
