//
//  FilmModel.swift
//  FilmsProject
//
//  Created by Тимур Жексимбаев on 17.07.2023.
//

import Foundation

struct TopFilms: Codable {
    let pagesCount: Int?
    let films: [Film]?
}


struct Film: Codable {
    let filmId: Int?
    let nameRu: String?
    let year: String?
    let filmLength: String?
    let genres: [Genre]?
    let rating: String?
    let posterUrl: String?
}

extension Film {
    static let example = Film(filmId: 0, nameRu: "default name", year: "default year", filmLength: "default lenght", genres: [Genre(genre: "default genre")], rating: "1.1",  posterUrl: "default poster")
}

struct Genre: Codable {
    let genre: String?
}


