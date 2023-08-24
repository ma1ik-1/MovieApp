//
//  Cast.swift
//  GLMovie
//
//  Created by Malik on 03/07/2023.
//

import Foundation
import SwiftUI

struct CastResponse: Decodable {
    let id: Int
    let cast: [Cast]
}

struct Cast: Decodable, Identifiable {
    let id: Int
    let name: String?
    let profilePath: String?

    var avatarURL: URL? {
        guard let profilePath else { return nil }
        return URL(string: APIConfig.baseImageURL.rawValue + "/w185" + profilePath)
    }
}
