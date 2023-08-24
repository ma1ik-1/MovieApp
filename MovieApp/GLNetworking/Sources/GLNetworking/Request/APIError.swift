//
//  APIError.swift
//  
//
//  Created by Wei Lu on 17/03/2023.
//

import Foundation

public enum APIError: Error, Equatable {
    case unknown
    case noToken
    case emptyContent // 204
    case unauthorized // 401
    case badRequest(statusCode: Int)
    case decodingError
    case encodingError
    case buildRequestError
    case invalidToken
}
