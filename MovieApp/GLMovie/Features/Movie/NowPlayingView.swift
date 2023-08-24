//
//  NowPlayingView.swift
//  test
//
//  Created by Malik on 12/06/2023.
//

import SwiftUI
struct NowPlayingView: View {
    let movies: [Movie]
    let gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Binding var selectedMovie: Movie? // Add selectedMovie as a binding
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 20) {
                ForEach(movies) { movie in
                    Button {
                        selectedMovie = movie // Set the selectedMovie to trigger the fullScreenCover
                    } label: {
                        Image(movie.poster)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                    }
                }
            }
            .padding()
        }
    }
}

struct NowPlayingView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingView(movies: Movie.mockMovies(), selectedMovie: .constant(nil))
    }
}
