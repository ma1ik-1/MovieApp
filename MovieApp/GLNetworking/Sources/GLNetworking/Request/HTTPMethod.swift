//
//  HTTPMethod.swift
//  
//
//  Created by Wei Lu on 18/03/2023.
//

import Foundation

public enum HTTPMethod {
    case get
    case post(Encodable?)
    case put(Encodable?)
    case delete
}

extension HTTPMethod: CustomStringConvertible {
    public var description: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        }
    }
}

public extension HTTPMethod {
    var body: Encodable? {
        switch self {
        case .get, .delete: return nil
        case .post(let body), .put(let body): return body
        }
    }

    func encodedBody(dateEncodingStrategy: JSONEncoder.DateEncodingStrategy) throws -> Data? {
        guard let body else { return nil }
        return try JSONEncoder.default.encode(body)
    }
}
