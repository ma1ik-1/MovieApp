//
//  MovieRequest.swift
//  GLMovie
//
//  Created by Wei Lu on 16/06/2023.
//

import Foundation
import GLNetworking

enum MovieRequest: HTTPRequest {
    case popular
    case topRated
    case nowPlaying
    case upcoming

    case details(String)
    case images(String)
    case reviews(Int)
    case cast(Int)
    case search(String)

    var path: String? {
        switch self {
        case .popular:
            return "/movie/popular"
        case .details(let movieId):
            return "/movie/\(movieId)"
        case .images(let movieId):
            return "/movie/\(movieId)/images"
        case .topRated:
            return "/movie/top_rated"
        case .nowPlaying:
            return "/movie/now_playing"
        case .upcoming:
            return "/movie/upcoming"
        case .reviews(let movieId):
            return "/movie/\(movieId)/reviews"
        case .cast(let movieId):
            return "/movie/\(movieId)/credits"
        case .search:
            return "/search/movie"
        }
    }

    var parameters: [String: String] {
        switch self {
        case .popular, .topRated, .nowPlaying, .details, .upcoming, .reviews, .cast:
            return [
                "language": "en",
                "page": "1",
                "region": "GB"
            ]
        case .search(let searchParam):
            return [
                "query": searchParam,
                "language": "en",
                "page": "1",
                "region": "GB"
            ]
        case .images:
            return [:]
        }
    }

    var headers: [HTTPHeader: HTTPHeaderValue] {
        [
            .authorization: .bearer(token: APIConfig.accessToken.rawValue),
            .contentType: .json
        ]
    }
}
