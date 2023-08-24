//
//  SearchViewModelTests.swift
//  GLMovieTests
//
//  Created by Malik on 14/08/2023.
//

import XCTest
import Combine
import GLNetworking
@testable import GLMovie

final class MockSearchMovieService: MovieServiceType {
    
    var searchResponse: MoviesResponse?
    var searchError: APIError?
    
    func fetchListMovies(request: GLMovie.MovieRequest) -> AnyPublisher<GLMovie.MoviesResponse, GLNetworking.APIError> {
        return Fail(error: .unknown).eraseToAnyPublisher() // Not used in CastViewModelTests
    }
    
    func fetchMovie(id: String) -> AnyPublisher<GLMovie.Movie, GLNetworking.APIError> {
        return Fail(error: .unknown).eraseToAnyPublisher() // Not used in CastViewModelTests
    }
    
    func fetchReviews(movieID: Int) -> AnyPublisher<GLMovie.ReviewResponse, GLNetworking.APIError> {
        return Fail(error: .unknown).eraseToAnyPublisher() // Not used in CastViewModelTests
    }
    
    func fetchCast(movieID: Int) -> AnyPublisher<GLMovie.CastResponse, GLNetworking.APIError> {
        return Fail(error: .unknown).eraseToAnyPublisher() // Not used in CastViewModelTests
    }

    func searchMovies(query: String) -> AnyPublisher<MoviesResponse, APIError> {
        if let error = searchError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        if let response = searchResponse {
            return Just(response)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: .unknown).eraseToAnyPublisher()
    }
}

final class SearchViewModelTests: XCTestCase {
    
    private var subject: SearchViewModel!
    private var mockService: MockSearchMovieService!
    
    private var cancellables = Set<AnyCancellable>()
    private var debouncedSearchAction: ((String) -> Void)!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = MockSearchMovieService()
        subject = SearchViewModel(service: mockService)
    }
    
    override func tearDownWithError() throws {
        subject = nil
        mockService = nil
        cancellables.removeAll()
        try super.tearDownWithError()
    }
    
    func test_searchMovies_withSuccessResponse_updatesSearchResult() {
        let mockResponse = MoviesResponse(page: 1, results: [
            Movie.mock()
        ], totalPages: 1, totalResults: 1)
        mockService.searchResponse = mockResponse
        
        let query = "test"
        subject.searchMovies(query: query)
        
        XCTAssertEqual(subject.searchResult, mockResponse.results)
        XCTAssertNil(subject.error)
    }
    
    func test_searchMovies_withErrorResponse_updatesError() {
        let error = APIError.badRequest(statusCode: 400)
        mockService.searchError = error
        
        let query = "test"
        subject.searchMovies(query: query)
        
        XCTAssertEqual(subject.error, error)
        XCTAssertTrue(subject.searchResult.isEmpty)
    }
}

