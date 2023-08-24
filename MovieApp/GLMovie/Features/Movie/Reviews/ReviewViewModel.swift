//
//  ReviewViewModel.swift
//  GLMovie
//
//  Created by Malik on 23/06/2023.
//

import Foundation
import Combine
import GLNetworking

final class ReviewViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var error: APIError?

    private let movieID: Int
    private let service: MovieServiceType
    private var cancellables = Set<AnyCancellable>()

    init(movieID: Int, service: MovieServiceType = MovieService()) {
        self.movieID = movieID
        self.service = service
    }

    func fetchReview() {
        service.fetchReviews(movieID: movieID)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] reviewResponse in
                self?.error = nil
                self?.reviews = reviewResponse.results
            }
            .store(in: &cancellables)
    }
}
