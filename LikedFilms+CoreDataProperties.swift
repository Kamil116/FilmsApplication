//
//  LikedFilms+CoreDataProperties.swift
//  FilmsApplication
//
//  Created by Тимур Жексимбаев on 10.08.2023.
//
//

import Foundation
import CoreData


extension LikedFilms {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikedFilms> {
        return NSFetchRequest<LikedFilms>(entityName: "LikedFilms")
    }

    @NSManaged public var id: Int64
    @NSManaged public var genre: String?
    @NSManaged public var length: String?
    @NSManaged public var name: String?
    @NSManaged public var poster: String?
    @NSManaged public var rating: String?
    @NSManaged public var year: String?

}

extension LikedFilms : Identifiable {

}
