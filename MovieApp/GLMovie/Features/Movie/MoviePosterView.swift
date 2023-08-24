//
//  MoviePosterView.swift
//  GLMovie
//
//  Created by Malik on 13/06/2023.
//

import SwiftUI

struct MoviePosterView: View {
    private let movies: [Movie]
    private let posterFrame = CGSize(width: 144, height: 210)

    init(movies: [Movie]) {
        self.movies = movies
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(Array(movies.enumerated()), id: \.element.id) { index, movie in
                    VStack {
                        NavigationLink(destination: MovieDetailView(viewModel: .init(movieID: "\(movie.id)"))) {
                            MovieImageView(imageURL: movie.posterURL, frame: posterFrame)
                                .frame(width: posterFrame.width, height: posterFrame.height)
                            Text("\(index + 1)")
                                .font(.system(size: 72, weight: .bold))
                                .foregroundColor(.blue)
                                .offset(x: -160, y: 80)
                        }
                    }
                }
            }
        }
    }
}

struct MoviePosterView_Previews: PreviewProvider {
    static var previews: some View {
        MoviePosterView(movies: [.mock()])
    }
}
