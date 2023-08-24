//
//  HomeViewModel.swift
//  GLMovie
//
//  Created by Wei Lu on 16/06/2023.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var state: State = .idle
    private let service: MovieServiceType
    private var cancellable = Set<AnyCancellable>()

    private(set) var popularMovies: [Movie] = []
    private(set) var topRateMovies: [Movie] = []
    private(set) var nowPlayingMovies: [Movie] = []
    private(set) var upcomingMovies: [Movie] = []

    init(service: MovieServiceType = MovieService()) {
        self.service = service
    }

    func fetchMovies() {
        state = .loading
        Publishers.Zip4(
            service.fetchListMovies(request: .popular),
            service.fetchListMovies(request: .topRated),
            service.fetchListMovies(request: .nowPlaying),
            service.fetchListMovies(request: .upcoming)
        )
        .sink { completion in
            if case .failure = completion {
                self.state = .error(.networkFailed)
            }
        } receiveValue: { popularResp, topRateResp, nowPlayingResp, upcomingResp in
            self.popularMovies = popularResp.results
            self.topRateMovies = topRateResp.results
            self.nowPlayingMovies = nowPlayingResp.results
            self.upcomingMovies = upcomingResp.results
            self.state = .response
        }
        .store(in: &cancellable)
    }

    var needLoad: Bool {
        switch state {
        case .idle, .error:
            return true
        default:
            return false
        }
    }

    var isLoading: Bool {
        state == .loading
    }
}
extension HomeViewModel {
    enum State: Equatable {
        case idle
        case loading
        case response
        case error(HomeViewError)
    }
    enum HomeViewError: Error, Equatable {
        case networkFailed
    }
}
