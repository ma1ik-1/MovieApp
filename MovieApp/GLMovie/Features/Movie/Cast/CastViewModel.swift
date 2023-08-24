//
//  CastViewModel.swift
//  GLMovie
//
//  Created by Malik on 03/07/2023.
//

import Foundation
import Combine
import GLNetworking

final class CastViewModel: ObservableObject {
    @Published var cast: [Cast] = []
    @Published var error: APIError?

    private let movieID: Int
    private let service: MovieServiceType
    private var cancellables = Set<AnyCancellable>()

    init(movieID: Int, service: MovieServiceType = MovieService()) {
        self.movieID = movieID
        self.service = service
    }

    func fetchCast() {
        service.fetchCast(movieID: movieID)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] castResponse in
                self?.error = nil
                self?.cast = castResponse.cast
            }
            .store(in: &cancellables)
    }
}
