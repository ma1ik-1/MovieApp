//
//  MoviesResponse.swift
//  GLMovie
//
//  Created by Wei Lu on 17/06/2023.
//

import Foundation

struct MoviesResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
}
