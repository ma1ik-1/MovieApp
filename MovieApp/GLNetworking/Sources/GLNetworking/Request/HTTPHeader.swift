//
//  HTTPHeader.swift
//  
//
//  Created by Wei Lu on 18/03/2023.
//

import Foundation

public enum HTTPHeader: String, CaseIterable {
    case authorization = "Authorization"
    case contentType = "Content-Type"
}

public enum HTTPHeaderValue: Equatable {
    case bearer(token: String)
    case json
    case urlencoded
    case pdf
    case custom(value: String)
}
