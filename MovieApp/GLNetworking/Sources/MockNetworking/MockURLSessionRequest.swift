//
//  MockURLSessionRequest.swift
//  
//
//  Created by Wei Lu on 25/03/2023.
//

import Foundation
import GLNetworking
import Combine

public final class MockURLSessionRequest: URLSessionRequest {
    public var data: Data?
    public var error: APIError?

    public init() {}

    public func jsonRequestPublisher<T: Decodable>(
        request: URLRequest,
        decoder: JSONDecoder
    ) -> AnyPublisher<T, APIError> {
        if let error {
            return Fail(error: error).eraseToAnyPublisher()
        }

        if let data {
            guard let object = try? JSONDecoder.default.decode(T.self, from: data) else {
                return Fail(error: APIError.decodingError).eraseToAnyPublisher()
            }
            return Just(object).setFailureType(to: APIError.self).eraseToAnyPublisher()
        }

        return Fail(error: APIError.unknown).eraseToAnyPublisher()
    }

    public func dataRequestPublisher(request: URLRequest) -> AnyPublisher<Data, APIError> {
        if let error {
            return Fail(error: error).eraseToAnyPublisher()
        }

        if let data {
            return Just(data).setFailureType(to: APIError.self).eraseToAnyPublisher()
        }

        return Fail(error: APIError.unknown).eraseToAnyPublisher()
    }

    public func emptyResponsePublisher(request: URLRequest) -> AnyPublisher<Void, APIError> {
        if let error {
            return Fail(error: error).eraseToAnyPublisher()
        }

        return Just(()).setFailureType(to: APIError.self).eraseToAnyPublisher()
    }
}
