import XCTest
import Combine
import GLNetworking
@testable import GLMovie

final class MockCastService: MovieServiceType {
    
    var castData: Data?
    var castError: APIError?
    
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
        if let error = castError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        if let data = castData {
            guard let object = try? JSONDecoder().decode(GLMovie.CastResponse.self, from: data) else {
                return Fail(error: APIError.decodingError).eraseToAnyPublisher()
            }
            return Just(object).setFailureType(to: GLNetworking.APIError.self).eraseToAnyPublisher()
        }
        
        return Fail(error: .unknown).eraseToAnyPublisher()
    }
    
    func searchMovies(query: String) -> AnyPublisher<GLMovie.MoviesResponse, GLNetworking.APIError> {
        return Fail(error: .unknown).eraseToAnyPublisher() // Not used in CastViewModelTests
    }
}

final class CastViewModelTests: XCTestCase {
    
    private var subject: CastViewModel!
    private var mockService: MockCastService!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = MockCastService()
        subject = CastViewModel(movieID: 550, service: mockService)
    }
    
    override func tearDownWithError() throws {
        subject = nil
        mockService = nil
        cancellables.removeAll()
        try super.tearDownWithError()
    }
    
    func test_fetchCast_withSuccessResponse_returnExpectedObjects() {
        let castData: [String: Any] = [
            "id": 550,
            "cast": [
                [
                    "id": 819,
                    "name": "Edward Norton",
                    "profilePath": "/5XBzD5WuTyVQZeS4VI25z2moMeY"
                ] as [String : Any]
            ]
        ]
        
        mockService.castData = try? JSONSerialization.data(withJSONObject: castData, options: [])
        
        let expect = expectation(description: "fetch cast list")
        subject.$error
            .dropFirst()
            .sink { error in
                XCTAssertNil(error) // Make sure there's no error
            }
            .store(in: &cancellables)
        
        subject.$cast
            .dropFirst()
            .sink { cast in
                XCTAssertEqual(cast.count, 1)
                XCTAssertEqual(cast[0].name, "Edward Norton")
                expect.fulfill()
            }
            .store(in: &cancellables)
        
        subject.fetchCast()
        
        wait(for: [expect], timeout: 3)
    }
    
    func test_fetchCast_withErrorResponse_returnExpectedObjects() {
        mockService.castError = APIError.badRequest(statusCode: 400)
        
        let expect = expectation(description: "fetch cast list")
        
        var receivedError: APIError?
        var receivedCast: [GLMovie.Cast]?
        
        let errorSink = subject.$error
            .sink { error in
                receivedError = error
                if receivedCast != nil {
                    expect.fulfill()
                }
            }
        
        let castSink = subject.$cast
            .sink { cast in
                receivedCast = cast
                if receivedError != nil {
                    expect.fulfill()
                }
            }
        
        subject.fetchCast()
        
        wait(for: [expect], timeout: 3)
        
        // Assert the results
        XCTAssertNotNil(receivedError)
        XCTAssertEqual(receivedCast?.count, 0)
        
        // Cancel the sinks to avoid retain cycles
        errorSink.cancel()
        castSink.cancel()
    }
}

