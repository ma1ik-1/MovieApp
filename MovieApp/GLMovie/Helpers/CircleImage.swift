//
//  CircleImage.swift
//  Project
//
//  Created by Malik on 25/05/2023.
//

import SwiftUI

struct CircleImage: View {
    var url: URL
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .frame(width: 95, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 10)
        } placeholder: {
            Color.gray
                .frame(width: 95, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 10)
        }
    }
}
