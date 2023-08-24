//
//  MovieViewModelTests.swift
//  GLMovieTests
//
//  Created by Malik on 14/08/2023.
//

import XCTest
import Combine
import GLNetworking
@testable import GLMovie

final class MovieViewModelTests: XCTestCase {
    
    private var subject: MovieViewModel!
    private var mockService: MockMovieService!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = MockMovieService()
        subject = MovieViewModel(movieID: "19995", service: mockService)
    }
    
    override func tearDownWithError() throws {
        subject = nil
        mockService = nil
        cancellables.removeAll()
        try super.tearDownWithError()
    }
    
    func test_fetchMovie_withSuccessResponse_returnExpectedMovie() {
        let mockMovie = Movie.mock()
        mockService.data = try? JSONEncoder().encode(mockMovie)
        
        let expect = expectation(description: "fetch movie")
        var receivedMovie: Movie?
        
        let cancellable = subject.$movie
            .sink { movie in
                receivedMovie = movie
                
                if let movie = movie {
                    XCTAssertEqual(movie.title, mockMovie.title)
                    XCTAssertEqual(movie.runtime, mockMovie.runtime)
                    XCTAssertEqual(movie.releaseDate, mockMovie.releaseDate)
                    
                    expect.fulfill()
                }
            }

        cancellable.store(in: &cancellables)
        
        subject.fetchMovie()
        
        wait(for: [expect], timeout: 3)

        if let receivedMovie = receivedMovie {
            XCTAssertEqual(receivedMovie.title, mockMovie.title)
            XCTAssertEqual(receivedMovie.runtime, mockMovie.runtime)
            XCTAssertEqual(receivedMovie.releaseDate, mockMovie.releaseDate)
        } else {
            XCTFail("Received movie is nil")
        }
    }


    func test_fetchMovie_withErrorResponse_returnNilMovie() {
        mockService.error = APIError.badRequest(statusCode: 400)
        
        let expect = expectation(description: "fetch movie")
        subject.$movie
            .sink { movie in
                XCTAssertNil(movie)
                expect.fulfill()
            }
            .store(in: &cancellables)
        
        subject.fetchMovie()
        
        wait(for: [expect], timeout: 3)
    }
    
    func test_title_withMovie_returnExpectedTitle() {
        let mockMovie = Movie.mock(title: "Avatar")
        subject.movie = mockMovie
        XCTAssertEqual(subject.title, "Avatar")
    }
    
    func test_runtime_withMovie_returnExpectedRuntime() {
        let mockMovie = Movie.mock(runtime: 148)
        subject.movie = mockMovie
        XCTAssertEqual(subject.runtime, "148 mins")
    }
    
    func test_released_withMovie_returnExpectedReleaseDate() {
        let mockMovie = Movie.mock(releaseDate: "2023-05-19")
        subject.movie = mockMovie
        XCTAssertEqual(subject.released, "2023-05-19")
    }
}
