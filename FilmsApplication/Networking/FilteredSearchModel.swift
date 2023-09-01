//
//  SearchModel.swift
//  FilmsApplication
//
//  Created by Тимур Жексимбаев on 06.08.2023.
//

import Foundation

struct FilteredSearchModel: Codable {
    let total: Int?
    let totalPages: Int?
    let items: [MovieDetails]?
}
