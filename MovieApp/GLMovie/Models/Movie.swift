//
//  Movie.swift
//  Project
//
//  Created by Malik on 25/05/2023.
//

import Foundation
import SwiftUI

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let releaseDate: String
    let overview: String
    let adult: Bool
    let voteAverage: Double

    // make this as private variable, then using `posterURL`
    private let posterPath: String?
    private let backdropPath: String?

    // these variable are not appeared on `popular` or `top_view` response,
    // only appeared on `detail` API response, so make them as optional & nil value as default.
    var homepage: String?
    var runtime: Int?

    // readonly variables
    var posterURL: URL? {
        // TMDB image format ref: https://developer.themoviedb.org/docs/image-basics
        guard let posterPath else { return nil }
        return URL(string: APIConfig.baseImageURL.rawValue + "/w500" + posterPath)
    }
    var backdropURL: URL? {
        // TMDB image format ref: https://developer.themoviedb.org/docs/image-basics
        guard let backdropPath else { return nil }
        return URL(string: APIConfig.baseImageURL.rawValue + "/w780" + backdropPath)
    }
}

extension Movie {
    static func mock(
        id: Int = 1,
        title: String = "Avatar",
        releaseDate: String = "2023-05-19",
        posterPath: String? = "/fiVW06jE7z9YnO4trhaMEdclSiC.jpg",
        backdropPath: String? = "/nGxUxi3PfXDRm7Vg95VBNgNM8yc.jpg",
        overview: String = "A paraplegic marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home.",
        adult: Bool = false,
        voteAverage: Double = 8.5,
        homePage: String? = nil,
        runtime: Int? = 148
    ) -> Movie {
        .init(
            id: id,
            title: title,
            releaseDate: releaseDate,
            overview: overview,
            adult: adult,
            voteAverage: voteAverage,
            posterPath: posterPath,
            backdropPath: backdropPath,
            homepage: homePage,
            runtime: runtime
        )
    }

    static func mockMovies() -> [Movie] {
        return [
            mock(title: "Avatar"),
            mock(title: "SpiderMan")
        ]
    }
}

extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        // Compare properties of Movie to determine equality
        return lhs.id == rhs.id // Assuming 'id' is a unique identifier for a Movie
    }
}

