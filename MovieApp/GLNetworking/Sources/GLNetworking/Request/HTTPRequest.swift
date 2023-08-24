//
//  HTTPRequest.swift
//
//
//  Created by Wei Lu on 18/03/2023.
//

import Foundation

/// Request Details
public protocol HTTPRequest {
    var baseURL: URL { get }
    var path: String? { get }
    var method: HTTPMethod { get }
    var headers: [HTTPHeader: HTTPHeaderValue] { get }
    var parameters: [String: String] { get }
    var timeout: TimeInterval { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy { get }
}

public extension HTTPRequest {
    var path: String? { nil }
    var method: HTTPMethod { .get }
    var headers: [HTTPHeader: HTTPHeaderValue] { [:] }
    var parameters: [String: String] { [:] }
    var timeout: TimeInterval { 30 }
    var cachePolicy: URLRequest.CachePolicy { .useProtocolCachePolicy }
    var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy { .formatted(.serverTimeFormat) }
}
