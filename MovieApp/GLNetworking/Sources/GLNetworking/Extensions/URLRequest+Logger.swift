//
//  URLRequest.swift
//  PayDashboard
//
//  Created by Pranay Dalal on 02/03/23.
//

import Foundation

public extension URLRequest {
    var completeDescription: String {
        """
        URL: \(url?.absoluteString ?? "")
        Method: \(httpMethod ?? "")\n
        """
    }
}
