//
//  URLSession+Extension.swift
//  
//
//  Created by Wei Lu on 17/03/2023.
//

import Foundation
import Combine

public protocol URLSessionRequest {
    func jsonRequestPublisher<T: Decodable>(request: URLRequest, decoder: JSONDecoder) -> AnyPublisher<T, APIError>
    func dataRequestPublisher(request: URLRequest) -> AnyPublisher<Data, APIError>
}

extension URLSession: URLSessionRequest {
    /// async networking request(Combine) to return a `Decodable` object
    /// - Parameters:
    ///   - request: URLRequest, should be created from ``URLRequestBuilder``
    ///   - decoder: JSON decoder
    /// - Returns: requesed decodable Object.
    public func jsonRequestPublisher<T: Decodable>(
        request: URLRequest,
        decoder: JSONDecoder = JSONDecoder.default
    ) -> AnyPublisher<T, APIError> {
        dataRequestPublisher(request: request)
            .decode(type: T.self, decoder: decoder)
            .mapError { [weak self] error -> APIError in
                switch error {
                case is DecodingError:
                    let log = "Network response: \n\(request.completeDescription)"
                    self?.logger(header: log, message: "decoding (\(T.self)) Error: \(error)")
                    return APIError.decodingError
                case is APIError:
                    // swiftlint:disable force_cast
                    return error as! APIError
                    // swiftlint:enable force_cast
                default:
                    return APIError.unknown
                }
            }
            .eraseToAnyPublisher()
    }

    /// async networking reqeust (Combine) to return a data
    /// - Parameter request: URLRequest, should be created from ``URLRequestBuilder``
    /// - Returns: Data
    public func dataRequestPublisher(request: URLRequest) -> AnyPublisher<Data, APIError> {
        let log = "Network response: \n\(request.completeDescription)"
        return dataTaskPublisher(for: request)
            .tryMap { [weak self] result in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw APIError.unknown
                }

                try self?.handleResponse(httpResponse, log: log, data: result.data)

                // handle expected empty response
                if result.data.isEmpty {
                    if let modifiedData = try? JSONEncoder.default.encode(EmptyResponse()) {
                        return modifiedData
                    }
                }

                return result.data
            }
            .mapError { [weak self] error -> APIError in
                guard let error = error as? APIError else {
                    self?.logger(header: log, message: "Unknown Error!!!")
                    return APIError.unknown
                }
                return error
            }
            .eraseToAnyPublisher()
    }

    private func handleResponse(_ httpResponse: HTTPURLResponse, log: String, data: Data?) throws {
        switch httpResponse.statusCode {
        case 200..<204, 205...299:
            logger(header: log, message: "Success Body: \(String(data: data ?? Data(), encoding: .utf8) ?? "")")
        case 204:
            logger(header: log, message: "Empty Response Content - 204")
            throw APIError.emptyContent
        case 401:
            logger(header: log, message: "Unauthorized Error Code - 401")
            logger(header: log, message: "Failure Body: \(String(data: data ?? Data(), encoding: .utf8) ?? "")")
            throw APIError.unauthorized
        default:
            logger(header: log, message: "HTTPS Error Code - \(httpResponse.statusCode)")
            logger(header: log, message: "Failure Body: \(String(data: data ?? Data(), encoding: .utf8) ?? "")")
            throw APIError.badRequest(statusCode: httpResponse.statusCode)
        }
    }

    private func logger(header: String? = nil, message: String? = nil) {
        #if DEBUG
        print("Request log: \(header ?? "") \(message ?? "")")
        #endif
    }
}
