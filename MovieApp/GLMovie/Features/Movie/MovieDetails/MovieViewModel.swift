//
//  MovieViewModel.swift
//  GLMovie
//
//  Created by Wei Lu on 15/06/2023.
//

import Foundation
import Combine
import GLNetworking

final class MovieViewModel: ObservableObject {
    @Published var movie: Movie?
    @Published var error: APIError?

    private let movieID: String
    private let service: MovieServiceType
    private var cancellables = Set<AnyCancellable>()

    init(movieID: String, service: MovieServiceType = MovieService()) {
        self.movieID = movieID
        self.service = service
    }

    func fetchMovie() {
        service.fetchMovie(id: movieID)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] movie in
                self?.error = nil
                self?.movie = movie
            }
            .store(in: &cancellables)
    }

    var title: String {
        movie?.title ?? "-"
    }

    var runtime: String {
        "\(movie?.runtime ?? 0) mins"
    }

    var released: String {
        movie?.releaseDate ?? "-"
    }
}
