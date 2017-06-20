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
typealias fetchRatingsResponse = ([RatingsMO]?, Bool, NSError?) -> Void

enum ratingsResult {
    case success([RatingsMO])
    case noResults
    case failure(Error)
}

class CoreDataService {
 
    static func fetchFavouritedMovies(onCompletion: @escaping fetchMoviesResponse) {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        
        let sortByMovieTitle = NSSortDescriptor(key: #keyPath(Movie.title), ascending: true)
        fetchRequest.sortDescriptors = [sortByMovieTitle]
        let viewContext = CoredataManager.sharedInstance.persistentContainer.viewContext
        
        viewContext.performAndWait {
            do {
                let allMovies = try viewContext.fetch(fetchRequest)
                onCompletion(allMovies, true, nil)
            } catch let error{
                onCompletion(nil, false, error as NSError)
            }
        }
    }
    
    static func fetchAllRatings(onCompletion: @escaping (ratingsResult) -> Void) {
        let fetchRequest: NSFetchRequest<RatingsMO> = RatingsMO.fetchRequest()
        let sortBySource = NSSortDescriptor(key: #keyPath(RatingsMO.source), ascending: true)
        fetchRequest.sortDescriptors = [sortBySource]
        
        let viewContext = CoredataManager.sharedInstance.persistentContainer.viewContext
        viewContext.performAndWait {
            do {
                let allRatings = try viewContext.fetch(fetchRequest)
                if allRatings.isEmpty {
                    onCompletion(.noResults)
                } else {
                    onCompletion(.success(allRatings))
                }
            } catch let error{
                onCompletion(.failure(error))
            }
        }
    }
    
    static func saveDetailedMovie(details: MovieDetail) {
        let context = CoredataManager.sharedInstance.persistentContainer.viewContext
        context.performAndWait {
            let movieManagedObject = Movie(context: context)
            movieManagedObject.imdbID = details.imdbID
            movieManagedObject.plot = details.plot
            movieManagedObject.poster = details.poster
            movieManagedObject.title = details.title
            


            for rating in details.ratings! {
                let entityRatings = NSEntityDescription.entity(forEntityName: "RatingsMO", in: context)
                let newRating = NSManagedObject(entity: entityRatings!, insertInto: context)
                newRating.setValue(rating.source, forKey: "source")
                newRating.setValue(rating.value, forKey: "value")
                newRating.setValue(NSSet(object: newRating), forKey: "movie")

            }
            
            CoredataManager.sharedInstance.saveContext()
        }
    }
    

}
