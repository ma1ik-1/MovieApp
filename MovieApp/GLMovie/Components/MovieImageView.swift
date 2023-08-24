//
//  MovieImageView.swift
//  GLMovie
//
//  Created by Wei Lu on 21/06/2023.
//

import SwiftUI

struct MovieImageView: View {
    private let imageURL: URL?
    private let frame: CGSize

    init(imageURL: URL?, frame: CGSize) {
        self.imageURL = imageURL
        self.frame = frame
    }

    var body: some View {
        VStack { // Wrap the content in a VStack
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .scaledToFit() // Maintain aspect ratio
            } placeholder: {
                ProgressView()
            }
            .frame(width: frame.width, height: frame.height)
            // Keep the frame size for tab view images
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black, lineWidth: 1)
            )
            .shadow(radius: 4)
            .padding(5)
        }
    }
}

struct MovieImageView_Previews: PreviewProvider {
    static var previews: some View {
        MovieImageView(imageURL: nil, frame: CGSize(width: 100, height: 145))
    }
}
