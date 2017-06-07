//
//  CoreDataService.swift
//  NewOMBD
//
//  Created by Ben Smith on 07/06/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import Foundation
import CoreData

typealias fetchMoviesResponse = ([Movie]?, Bool, NSError?) -> Void

class CoreDataService {
 
    static func fetchFavouritedMovies(onCompletion: @escaping fetchMoviesResponse) {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        
        let viewContext = CoredataManager.sharedInstance.persistentContainer.viewContext
        
        viewContext.perform {
            do {
                let allMovies = try viewContext.fetch(fetchRequest)
                onCompletion(allMovies, true, nil)
            } catch let error{
                onCompletion(nil, false, error as NSError)
            }
        }
    }
}
