//
//  BackgroundImage.swift
//  GLMovie
//
//  Created by Malik on 15/06/2023.
//

import SwiftUI

struct BackgroundImage: View {
    private let url: URL
    private let height: CGFloat
    private let width: CGFloat = UIScreen.main.bounds.width

    init(url: URL, height: CGFloat = 210) {
        self.url = url
        self.height = height
    }

    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
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
