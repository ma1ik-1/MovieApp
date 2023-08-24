//
//  HomeViewModelTests.swift
//  GLMovieTests
//
//  Created by Wei Lu on 11/08/2023.
//

import XCTest
import Combine
import GLNetworking
@testable import GLMovie

final class MockMovieService: MovieServiceType {
    
    var data: Data?
    var error: APIError?
    
    func fetchListMovies(request: MovieRequest) -> AnyPublisher<MoviesResponse, APIError> {
        if let error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        if let data {
            guard let object = try? JSONDecoder().decode(MoviesResponse.self, from: data) else {
                return Fail(error: APIError.decodingError).eraseToAnyPublisher()
            }
            return Just(object).setFailureType(to: APIError.self).eraseToAnyPublisher()
        }
        
        return Fail(error: .unknown).eraseToAnyPublisher()
    }
    
    func fetchMovie(id: String) -> AnyPublisher<GLMovie.Movie, GLNetworking.APIError> {
        if let error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        if let data {
            guard let object = try? JSONDecoder().decode(Movie.self, from: data) else {
                return Fail(error: APIError.decodingError).eraseToAnyPublisher()
            }
            return Just(object).setFailureType(to: APIError.self).eraseToAnyPublisher()
        }
        
        return Fail(error: .unknown).eraseToAnyPublisher()
    }
    
    func fetchReviews(movieID: Int) -> AnyPublisher<GLMovie.ReviewResponse, GLNetworking.APIError> {
        if let error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        if let data {
            guard let object = try? JSONDecoder().decode(ReviewResponse.self, from: data) else {
                return Fail(error: APIError.decodingError).eraseToAnyPublisher()
            }
            return Just(object).setFailureType(to: APIError.self).eraseToAnyPublisher()
        }
        
        return Fail(error: .unknown).eraseToAnyPublisher()
    }
    
    func fetchCast(movieID: Int) -> AnyPublisher<GLMovie.CastResponse, GLNetworking.APIError> {
        if let error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        if let data {
            guard let object = try? JSONDecoder().decode(CastResponse.self, from: data) else {
                return Fail(error: APIError.decodingError).eraseToAnyPublisher()
            }
            return Just(object).setFailureType(to: APIError.self).eraseToAnyPublisher()
        }
        
        return Fail(error: .unknown).eraseToAnyPublisher()
    }
    
    func searchMovies(query: String) -> AnyPublisher<GLMovie.MoviesResponse, GLNetworking.APIError> {
        if let error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        if let data {
            guard let object = try? JSONDecoder().decode(MoviesResponse.self, from: data) else {
                return Fail(error: APIError.decodingError).eraseToAnyPublisher()
            }
            return Just(object).setFailureType(to: APIError.self).eraseToAnyPublisher()
        }
        
        return Fail(error: .unknown).eraseToAnyPublisher()
    }
}

final class HomeViewModelTests: XCTestCase {
    
    private var subject: HomeViewModel!
    private var mockService: MockMovieService!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = MockMovieService()
        subject = HomeViewModel(service: mockService)
    }
    
    override func tearDownWithError() throws {
        subject = nil
        mockService = nil
        cancellables.removeAll()
        try super.tearDownWithError()
    }

    func test_needLoad_withDifferentState_returnExpectedValue() throws {
        subject.state = .idle
        XCTAssertTrue(subject.needLoad)
        
        subject.state = .loading
        XCTAssertFalse(subject.needLoad)
        
        subject.state = .error(.networkFailed)
        XCTAssertTrue(subject.needLoad)
        
        subject.state = .response
        XCTAssertFalse(subject.needLoad)
    }
    
    func test_loading_withLoadingState_returnTrue() {
        subject.state = .loading
        XCTAssertTrue(subject.isLoading)
    }

    func test_loading_withNotLoadingState_returnFalse() {
        subject.state = .idle
        XCTAssertFalse(subject.isLoading)
    }
    
    func test_fetchMovies_withSuccessResponse_returnExpectedObjects() {
        let mockResponse = MoviesResponse(page: 1, results: [
            Movie.mock()
        ], totalPages: 1, totalResults: 1)
        mockService.data = try? JSONEncoder().encode(mockResponse)
        
        let expect = expectation(description: "fetch movie list")
        subject.$state
            .dropFirst()
            .sink { state in
                if state == .loading {
                    // ignore
                } else if state == .response {
                    XCTAssertEqual(state, .response)
                    expect.fulfill()
                }
            }
            .store(in: &cancellables)
        
        subject.fetchMovies()
        
        wait(for: [expect], timeout: 3)
    }
    
    func test_fetchMovies_withErrorResponse_returnExpectedObjects() {
        mockService.error = APIError.badRequest(statusCode: 400)
        
        let expect = expectation(description: "fetch movie list")
        subject.$state
            .dropFirst()
            .sink { state in
                if state == .loading {
                    // ignore
                } else if state == .error(.networkFailed) {
                    XCTAssertEqual(state, .error(.networkFailed))
                    expect.fulfill()
                }
            }
            .store(in: &cancellables)
        
        subject.fetchMovies()
        
        wait(for: [expect], timeout: 3)
    }
}
