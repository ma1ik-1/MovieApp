//
//  Config.swift
//  GLMovie
//
//  Created by Wei Lu on 16/06/2023.
//

import Foundation
import GLNetworking

enum APIConfig: String {
    case baseURL
    case baseImageURL
    case apiKey
    case accessToken

    var rawValue: String {
        switch self {
        case .baseURL:
            return "https://api.themoviedb.org/3"
        case .baseImageURL:
            return "https://image.tmdb.org/t/p"
        case .apiKey:
            return "78e166975326fe880c913ca18bfdea1e"
        case .accessToken:
            // swiftlint:disable line_length
            return "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3OGUxNjY5NzUzMjZmZTg4MGM5MTNjYTE4YmZkZWExZSIsInN1YiI6IjYyMzEwODE4NjUxN2Q2MDA3ZTNhZjZjNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lCq_l0q8bQOktbpIu7bnX057_E97pBaV2xoIBRAX05A"
            // swiftlint:enable line_length
        }
    }
}

extension HTTPRequest {
    // swiftlint:disable force_unwrapping
    var baseURL: URL {
        URL(string: APIConfig.baseURL.rawValue)!
    }
    // swiftlint:enable force_unwrapping
}
