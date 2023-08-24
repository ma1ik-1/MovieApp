//
//  MockURLRequestBuilder.swift
//  
//
//  Created by Wei Lu on 26/03/2023.
//

import Foundation
import GLNetworking

// swiftlint:disable force_unwrapping
public final class MockURLRequestBuilder: URLRequestBuilderType {
    public var stubbedURLRequest: URLRequest?
    public var error: APIError?

    public init(
        stubbedURLRequest: URLRequest? = URLRequest(url: URL(string: "https://pb.api.com")!),
        error: APIError? = nil
    ) {
        self.stubbedURLRequest = stubbedURLRequest
        self.error = error
    }

    public func build(_ request: HTTPRequest) throws -> URLRequest {
        if let error {
            throw error
        }

        if let stubbedURLRequest {
            return stubbedURLRequest
        }

        throw APIError.unknown
    }
}
// swiftlint:enable force_unwrapping
