//
//  Movie+CoreDataProperties.swift
//  
//
//  Created by ben smith on 12/06/17.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie");
    }

    @NSManaged public var imdbID: String?
    @NSManaged public var plot: String?
    @NSManaged public var poster: String?
    @NSManaged public var title: String?
    @NSManaged public var ratings: NSSet?

}

// MARK: Generated accessors for ratings
extension Movie {

    @objc(addRatingsObject:)
    @NSManaged public func addToRatings(_ value: RatingsMO)

    @objc(removeRatingsObject:)
    @NSManaged public func removeFromRatings(_ value: RatingsMO)

    @objc(addRatings:)
    @NSManaged public func addToRatings(_ values: NSSet)

    @objc(removeRatings:)
    @NSManaged public func removeFromRatings(_ values: NSSet)

}
