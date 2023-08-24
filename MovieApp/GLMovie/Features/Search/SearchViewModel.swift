//
//  SearchViewModel.swift
//  GLMovie
//
//  Created by Wei Lu on 21/06/2023.
//

import Foundation
import Combine
import GLNetworking

final class SearchViewModel: ObservableObject {
    //    @Published var searchResult: [MoviesResponse] = []
    @Published var searchResult: [Movie] = []
    @Published var error: APIError?
    @Published var searchText: String = "" {
        didSet {
            debouncedSearchAction(searchText)
        }
    }

    private let service: MovieServiceType
    private var cancellables = Set<AnyCancellable>()
    private var debouncedSearchAction: ((String) -> Void)!

    init(service: MovieServiceType = MovieService()) {
        self.service = service
        setupDebouncedSearchAction()
    }

    private func setupDebouncedSearchAction() {
        debouncedSearchAction = debounce(delay: 0.2, queue: DispatchQueue.main) { [weak self] query in
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            self?.searchMovies(query: encodedQuery)
        }
    }

    func searchMovies(query: String) {
        service.searchMovies(query: query)
        //            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] searchResponse in
                self?.error = nil
                self?.searchResult = searchResponse.results
            }
            .store(in: &cancellables)
    }

    private func debounce<T>(delay: TimeInterval, queue: DispatchQueue, action: @escaping (T) -> Void) -> (T) -> Void {
        var lastFireTime: DispatchTime = .now()
        let dispatchDelay = DispatchTimeInterval.milliseconds(Int(delay * 1000))

        return { value in
            lastFireTime = .now()
            queue.asyncAfter(deadline: lastFireTime + dispatchDelay) {
                let when = lastFireTime + dispatchDelay
                let now = DispatchTime.now()
                if now.rawValue >= when.rawValue {
                    action(value)
                }
            }
        }
    }
}
