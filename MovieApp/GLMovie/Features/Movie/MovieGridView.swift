//
//  NowPlayingView.swift
//  test
//
//  Created by Malik on 12/06/2023.
//

import SwiftUI

struct MovieGridView: View {
    private let movies: [Movie]
    private let gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    private let gridFrame = CGSize(width: 100, height: 145)

    init(movies: [Movie]) {
        self.movies = movies
    }

    var body: some View {
        LazyVGrid(columns: gridItems, spacing: 20) {
            ForEach(movies) { movie in
                NavigationLink(destination: MovieDetailView(viewModel: .init(movieID: "\(movie.id)"))) {
                    MovieImageView(imageURL: movie.posterURL, frame: gridFrame)
                }
            }
        }
        .padding(10)
        .background(Color(red: 0.14, green: 0.16, blue: 0.20))
    }
}

struct MovieGridView_Previews: PreviewProvider {
    static var previews: some View {
        MovieGridView(movies: [])
            .environmentObject(HomeViewModel())
    }
}
