//
//  URLRequestBuilder.swift
//  
//
//  Created by Wei Lu on 18/03/2023.
//

import Foundation

public enum URLRequestBuilderError: Error {
    case invalidPath(String)
    case urlResolution
    case bodyEncoding(Error)
}

public protocol URLRequestBuilderType {
    func build(_ request: HTTPRequest) throws -> URLRequest
}

public struct URLRequestBuilder: URLRequestBuilderType {
    public init() {}

    /// generate a URLRequest based on passed `HTTPRequest`
    /// - Parameter request: request parameters, check ``HTTPRequest`` for more details.
    /// - Returns: URLRequest
    public func build(_ request: HTTPRequest) throws -> URLRequest {
        // path
        let path = request.path ?? ""
        guard path.first == "/" else {
            logger(message: "URLRequestBuilder: path must start with '/'")
            throw URLRequestBuilderError.invalidPath(path)
        }

        guard var components = URLComponents(string: request.baseURL.absoluteString + path) else {
            logger(message: "URLRequestBuilder: invalid Path")
            throw URLRequestBuilderError.invalidPath(path)
        }

        // parameters
        if request.headers[.contentType] != .urlencoded && !request.parameters.isEmpty {
            components.percentEncodedQueryItems = request.parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }

        // method, cache policy, timeout
        guard let url = components.url else {
            throw URLRequestBuilderError.urlResolution
        }

        var urlRequest = URLRequest(
            url: url,
            cachePolicy: request.cachePolicy,
            timeoutInterval: request.timeout
        )
        urlRequest.httpMethod = String(describing: request.method)

        // headers
        buildHeaders(for: request).forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }

        // body
        do {
            if request.headers[.contentType] == .urlencoded {
                urlRequest.httpBody = request.parameters.percentEncoded()
            } else {
                urlRequest.httpBody = try request.method.encodedBody(dateEncodingStrategy: request.dateEncodingStrategy)
            }
            return urlRequest
        } catch {
            logger(message: "URLRequestBuilder: encode body failed")
            throw URLRequestBuilderError.bodyEncoding(error)
        }
    }

    private func buildHeaders(for request: HTTPRequest) -> [String: String] {
        Dictionary(uniqueKeysWithValues: request.headers.map { key, value in
            let resultKey = key.rawValue
            let resultValue: String
            switch value {
            case .bearer(let token):
                resultValue = "Bearer " + token
            case .json:
                resultValue = "application/json"

            case .urlencoded:
                resultValue = "application/x-www-form-urlencoded"

            case .pdf:
                resultValue = "application/pdf"

            case .custom(value: let value):
                resultValue = value
            }
            return (resultKey, resultValue)
        })
    }

    private func logger(header: String? = nil, message: String? = nil) {
        #if DEBUG
        print("Request log: \(header ?? "") \(message ?? "")")
        #endif
    }
}
