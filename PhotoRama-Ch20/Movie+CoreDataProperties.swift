//
//  Movie+CoreDataProperties.swift
//  
//
//  Created by Ben Smith on 07/06/2017.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var imdbID: String?
    @NSManaged public var plot: String?
    @NSManaged public var poster: String?
    @NSManaged public var title: String?

}
