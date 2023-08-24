//
//  NetworkService.swift
//  GLMovie
//
//  Created by Wei Lu on 16/06/2023.
//

import Foundation
import Combine
import GLNetworking

protocol MovieServiceType {
    func fetchListMovies(request: MovieRequest) -> AnyPublisher<MoviesResponse, APIError>
    func fetchMovie(id: String) -> AnyPublisher<Movie, APIError>
    func fetchReviews(movieID: Int) -> AnyPublisher<ReviewResponse, APIError>
    func fetchCast(movieID: Int) -> AnyPublisher<CastResponse, APIError>
    func searchMovies(query: String) -> AnyPublisher<MoviesResponse, APIError>
}

final class MovieService: MovieServiceType {
    private let session: URLSession
    private let requestBuilder: URLRequestBuilder

    init(
        session: URLSession = .shared,
        requestBuilder: URLRequestBuilder = .init()
    ) {
        self.session = session
        self.requestBuilder = requestBuilder
    }

    func fetchListMovies(request: MovieRequest) -> AnyPublisher<MoviesResponse, APIError> {
        guard let request = try? requestBuilder.build(request) else {
            return Fail(error: APIError.buildRequestError).eraseToAnyPublisher()
        }

        return session.jsonRequestPublisher(request: request)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func fetchMovie(id: String) -> AnyPublisher<Movie, APIError> {
        guard let request = try? requestBuilder.build(MovieRequest.details(id)) else {
            return Fail(error: APIError.buildRequestError).eraseToAnyPublisher()
        }
        return session.jsonRequestPublisher(request: request)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func fetchReviews(movieID: Int) -> AnyPublisher<ReviewResponse, APIError> {
        guard let request = try? requestBuilder.build(MovieRequest.reviews(movieID)) else {
            return Fail(error: APIError.buildRequestError).eraseToAnyPublisher()
        }
        return session.jsonRequestPublisher(request: request)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func fetchCast(movieID: Int) -> AnyPublisher<CastResponse, APIError> {
        guard let request = try? requestBuilder.build(MovieRequest.cast(movieID)) else {
            return Fail(error: APIError.buildRequestError).eraseToAnyPublisher()
        }
        return session.jsonRequestPublisher(request: request)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func searchMovies(query: String) -> AnyPublisher<MoviesResponse, APIError> {
        guard let request = try? requestBuilder.build(MovieRequest.search(query)) else {
            return Fail(error: APIError.buildRequestError).eraseToAnyPublisher()
        }

        return session.jsonRequestPublisher(request: request)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
