//
//  ReviewViewModelTests.swift
//  GLMovieTests
//
//  Created by Abdul Malik on 14/08/2023.
//

import XCTest
import Combine
import GLNetworking
@testable import GLMovie

final class MockReviewService: MovieServiceType {
    
    var data: Data?
    var error: APIError?
    
    func fetchListMovies(request: GLMovie.MovieRequest) -> AnyPublisher<GLMovie.MoviesResponse, GLNetworking.APIError> {
        return Fail(error: .unknown).eraseToAnyPublisher() // Not used in CastViewModelTests
    }
    
    func fetchMovie(id: String) -> AnyPublisher<GLMovie.Movie, GLNetworking.APIError> {
        return Fail(error: .unknown).eraseToAnyPublisher() // Not used in CastViewModelTests
    }
    
    func fetchCast(movieID: Int) -> AnyPublisher<GLMovie.CastResponse, GLNetworking.APIError> {
        return Fail(error: .unknown).eraseToAnyPublisher()
    }
    
    func searchMovies(query: String) -> AnyPublisher<GLMovie.MoviesResponse, GLNetworking.APIError> {
        return Fail(error: .unknown).eraseToAnyPublisher()
    }
    
    func fetchReviews(movieID: Int) -> AnyPublisher<GLMovie.ReviewResponse, GLNetworking.APIError> {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        if let data = data {
            guard let object = try? JSONDecoder().decode(ReviewResponse.self, from: data) else {
                return Fail(error: APIError.decodingError).eraseToAnyPublisher()
            }
            return Just(object).setFailureType(to: APIError.self).eraseToAnyPublisher()
        }
        
        return Fail(error: .unknown).eraseToAnyPublisher()
    }
}

final class ReviewViewModelTests: XCTestCase {
    
    private var subject: ReviewViewModel!
    private var mockService: MockReviewService!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = MockReviewService()
        subject = ReviewViewModel(movieID: 550, service: mockService)
    }
    
    override func tearDownWithError() throws {
        subject = nil
        mockService = nil
        cancellables.removeAll()
        try super.tearDownWithError()
    }
    
    func test_fetchReview_withSuccessResponse_returnExpectedObjects() {
        mockService.data = try! JSONEncoder().encode(reviewData)
        
        subject.fetchReview()
        
        XCTAssertEqual(subject.reviews.count, reviewData.results.count)
        
        for (index, expectedReview) in reviewData.results.enumerated() {
            let fetchedReview = subject.reviews[index]
            
            XCTAssertEqual(fetchedReview.id, expectedReview.id)
            XCTAssertEqual(fetchedReview.author, expectedReview.author)
            XCTAssertEqual(fetchedReview.content, expectedReview.content)
            XCTAssertEqual(fetchedReview.url, expectedReview.url)
            XCTAssertEqual(fetchedReview.authorDetails.name, expectedReview.authorDetails.name)
            XCTAssertEqual(fetchedReview.authorDetails.username, expectedReview.authorDetails.username)
            XCTAssertEqual(fetchedReview.authorDetails.avatarPath, expectedReview.authorDetails.avatarPath)
            XCTAssertEqual(fetchedReview.authorDetails.rating, expectedReview.authorDetails.rating)
            
            // Check createdAt Date
            if let expectedCreatedAt = expectedReview.createdAt {
                XCTAssertNotNil(fetchedReview.createdAt)
                XCTAssertEqual(fetchedReview.createdAt, expectedCreatedAt)
            } else {
                XCTAssertNil(fetchedReview.createdAt)
            }
        }
    }
    
    func testFetchReviewWithErrorResponse() {
        // Set up the error to be returned by the mock service
        mockService.error = .unknown // Use .unknown as an example error
        
        // Perform the fetchReview() operation
        subject.fetchReview()
        
        // Verify that the error is set
        XCTAssertNotNil(subject.error)
        XCTAssertEqual(subject.error, .unknown)
        
        // Verify that the reviews array is empty
        XCTAssertTrue(subject.reviews.isEmpty)
    }
}
