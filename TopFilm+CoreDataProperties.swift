//
//  TopFilm+CoreDataProperties.swift
//  FilmsApplication
//
//  Created by Тимур Жексимбаев on 30.07.2023.
//
//

import Foundation
import CoreData


extension TopFilm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TopFilm> {
        return NSFetchRequest<TopFilm>(entityName: "TopFilm")
    }

    @NSManaged public var genre: String?
    @NSManaged public var id: Int64
    @NSManaged public var length: String?
    @NSManaged public var name: String?
    @NSManaged public var poster: String?
    @NSManaged public var rating: String?
    @NSManaged public var year: String?

}

extension TopFilm : Identifiable {

}
