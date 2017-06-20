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
  

            NetworkRequestManager.omdbRequest(with: url!, onCompletion: { (_ inner:() throws -> responseDictionary) -> Void in
                do {
                    let dict = try inner()
                    OperationQueue.main.addOperation {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "searchResults"),
                                                        object: self,
                                                        userInfo: dict)
                    }
                } catch {
                    let errorResponseDict = ["error": error]
                    OperationQueue.main.addOperation {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "omdbError"),
                                                        object: self,
                                                        userInfo: errorResponseDict)
                    }
                }
            })





        
    }
    
    static func getMovieDetailsByID(ID: String) {
        let url = omdbURLCreator.createOMDBURLWithComponents(term: .byImdbIDFull(ID))
        
        
            NetworkRequestManager.omdbRequest(with: url!, onCompletion: { (_ inner:() throws -> responseDictionary) -> Void in
                do {
                    let dict = try inner()

                    do {
                        try CoredataManager.sharedInstance.persistentContainer.viewContext.save()
                    } catch let error {
                        print(error.localizedDescription)
                    }
                    OperationQueue.main.addOperation {

                        NotificationCenter.default.post(name: Notification.Name(rawValue: "movieDetailNotification"),
                                                        object: self,
                                                        userInfo: dict)
                    }
                } catch {
                    OperationQueue.main.addOperation {

                        let errorResponseDict = ["error": error]
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "omdbError"),
                                                        object: self,
                                                        userInfo: errorResponseDict)
                    }
                }
            })

    }
}
