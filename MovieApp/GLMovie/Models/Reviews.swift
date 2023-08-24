//
//  Reviews.swift
//  GLMovie
//
//  Created by Malik on 15/06/2023.
//

import Foundation
import SwiftUI

struct ReviewResponse: Codable {
    let id: Int
    let page: Int
    let results: [Review]
    let totalPages: Int
    let totalResults: Int
}

struct Review: Codable, Identifiable {
    let id: String
    let author: String
    let authorDetails: AuthorDetail
    let content: String
    let url: URL?
    var createdAt: Date?
}

extension Review {
    struct AuthorDetail: Codable {
        let name: String?
        let username: String
        let avatarPath: String?
        let rating: Double?
        var avatarURL: URL? {
            guard let avatarPath = avatarPath else { return nil }
            return URL(string: APIConfig.baseImageURL.rawValue + "/w300" + avatarPath)
        }
    }
}

let reviewData: ReviewResponse = ReviewResponse(
    id: 550,
    page: 1,
    results: [
        Review(
            id: "5b1c13b9c3a36848f2026384",
            author: "Goddard",
            authorDetails: Review.AuthorDetail(
                name: "",
                username: "Goddard",
                avatarPath: nil,
                rating: nil
            ),
            content: "Pretty awesome movie. It shows what one crazy person can...",
            url: URL(string: "https://www.themoviedb.org/review/5b1c13b9c3a36848f2026384"),
            createdAt: nil
        ),
        Review(
            id: "5b3e1ba1925141144c007f17",
            author: "Brett Pascoe",
            authorDetails: Review.AuthorDetail(
                name: "Brett Pascoe",
                username: "SneekyNuts",
                avatarPath: nil,
                rating: 9
            ),
            content: "In my top 5 of all time favourite movies. Great story line and a movie you can watch...",
            url: URL(string: "https://www.themoviedb.org/review/5b3e1ba1925141144c007f17"),
            createdAt: nil
        ),
        Review(
            id: "5fba9c4a0792e1003f3a1294",
            author: "Manuel São Bento",
            authorDetails: Review.AuthorDetail(
                name: "Manuel São Bento",
                username: "msbreviews",
                avatarPath: nil,
                rating: 8
            ),
            content: "If you enjoy reading my Spoiler-Free reviews, please follow my blog...",
            url: URL(string: "https://www.themoviedb.org/review/5fba9c4a0792e1003f3a1294"),
            createdAt: nil
        ),
        // Add the remaining review data here...
        Review(
            id: "5ffe679d7d5db5003bc8340a",
            author: "r96sk",
            authorDetails: Review.AuthorDetail(
                name: "",
                username: "r96sk",
                avatarPath: nil,
                rating: 7
            ),
            content: "I didn't enjoy this, pretty much at all...",
            url: URL(string: "https://www.themoviedb.org/review/5ffe679d7d5db5003bc8340a"),
            createdAt: nil
        ),
        Review(
            id: "60918f96b3e6270029645c19",
            author: "rsanek",
            authorDetails: Review.AuthorDetail(
                name: "",
                username: "rsanek",
                avatarPath: nil,
                rating: 9
            ),
            content: "I was mostly neutral on this movie until the last third...",
            url: URL(string: "https://www.themoviedb.org/review/60918f96b3e6270029645c19"),
            createdAt: nil
        ),
        Review(
            id: "60df6c4f9979d2005d419e08",
            author: "Wuchak",
            authorDetails: Review.AuthorDetail(
                name: "",
                username: "Wuchak",
                avatarPath: "/4KVM1VkqmXLOuwj1jjaSdxbvBDk.jpg",
                rating: 6
            ),
            content: "_**Finding enlightenment thru beating each other...",
            url: URL(string: "https://www.themoviedb.org/review/60df6c4f9979d2005d419e08"),
            createdAt: nil
        ),
        Review(
            id: "60eddd855f622b005e51f938",
            author: "katch22",
            authorDetails: Review.AuthorDetail(
                name: "",
                username: "katch22",
                avatarPath: nil,
                rating: 8
            ),
            content: "Madness unbounded. Don't try to make sense of insanity, just ride a wild ride.",
            url: URL(string: "https://www.themoviedb.org/review/60eddd855f622b005e51f938"),
            createdAt: nil
        ),
        Review(
            id: "639576a62cefc200a2fd4f33",
            author: "alksjalksj",
            authorDetails: Review.AuthorDetail(
                name: "",
                username: "alksjalksj",
                avatarPath: "/vYtiI5wiy8iX7BaLbanPCHaNPUs.jpg",
                rating: 10
            ),
            content: "The best movie i've seen, also my head hurts",
            url: URL(string: "https://www.themoviedb.org/review/639576a62cefc200a2fd4f33"),
            createdAt: nil
        )
    ],
    totalPages: 1,
    totalResults: 8
)
