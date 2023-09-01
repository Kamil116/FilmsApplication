//
//  LikedFilmsDataController.swift
//  FilmsApplication
//
//  Created by Тимур Жексимбаев on 10.08.2023.
//

import Foundation
import UIKit
import CoreData

class LikedFilmsDataController: NSObject {
    static let shared = LikedFilmsDataController()
    private override init(){}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    private let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LikedFilms")
    
    public func createFilm(topFilm: Film) {
        guard let filmEntityDescription = NSEntityDescription.entity(forEntityName: "LikedFilms", in: context) else {
            return
        }
        
        let film = LikedFilms(entity: filmEntityDescription, insertInto: context)
        film.id = Int64(topFilm.filmId!)
        film.name = topFilm.nameRu ?? ""
        film.year = topFilm.year ?? ""
        film.length = topFilm.filmLength ?? ""
        film.genre = topFilm.genres?[0].genre ?? ""
        film.rating = topFilm.rating ?? ""
        film.poster = topFilm.posterUrl ?? ""
        
        appDelegate.saveContext()
    }
    

    
    public func deleteAllFilms() {
        do {
            let films = try? context.fetch(fetchRequest) as? [LikedFilms]
            
            films?.forEach { context.delete($0) }
        }
        appDelegate.saveContext()
    }
    
    public func deleteFilm(film: Film) {
        do {
            let films = try? context.fetch(fetchRequest) as? [LikedFilms]
            for likedFilm in films ?? [] {
                if likedFilm.id == film.filmId ?? 0 {
                    context.delete(likedFilm)
                    appDelegate.saveContext()
                    return
                }
            }
        }
    }
    
    public func checkIfItemExist(topFilm: Film) -> Bool {
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d" , topFilm.filmId!)
        do {
            let count = try context.count(for: fetchRequest)
            if count > 0 {
                return true
            }else {
                return false
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
    public func getFilms() -> [Film] {
        var result = [Film]()
        
        do {
            let films = try? context.fetch(fetchRequest) as? [LikedFilms]
            
            guard let allFilms = films else {
                return [Film.example]
            }
            
            for film in allFilms {
                result.append(Film(filmId: Int(film.id), nameRu: film.name, year: film.year, filmLength: film.length, genres: [Genre(genre: film.genre)], rating: film.rating, posterUrl: film.poster))
            }
            
            return result
        }
    }
}
