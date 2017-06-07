//
//  MovieDetail+CoreDataProperties.swift
//  
//
//  Created by Ben Smith on 07/06/2017.
//
//

import Foundation
import CoreData


extension MovieDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieDetail> {
        return NSFetchRequest<MovieDetail>(entityName: "MovieDetail")
    }

    @NSManaged public var omdbID: String?
    @NSManaged public var plot: String?
    @NSManaged public var poster: String?
    @NSManaged public var title: String?

}
