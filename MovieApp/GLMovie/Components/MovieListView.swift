//
//  MovieListView.swift
//  GLMovie
//
//  Created by Malik on 05/07/2023.
//

import SwiftUI

struct MovieListView: View {
    var movie: Movie
    var body: some View {
        HStack {
            // Movie Poster
            AsyncImage(url: movie.posterURL) { image in
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
            VStack(alignment: .leading) {
                // Movie Title
                Text(movie.title)
                    .font(.custom("Poppins", size: 20))
                    .padding(.bottom, 2)
                // Movie Rating
                Label("\(String(format: "%.2f", movie.voteAverage))", systemImage: "star")
                    .padding(.bottom, 2)
                // Movie Genre
                //                // Movie Release Date
                Label("\(movie.releaseDate)", systemImage: "calendar")
                    .padding(.bottom, 2)
                //                // Movie Duration
            }
            .background(Color(red: 0.14, green: 0.16, blue: 0.20))
            .foregroundColor(.white)
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading) // Align items to the left
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(movie: Movie.mock())
    }
}
