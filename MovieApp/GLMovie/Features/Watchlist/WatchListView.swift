//
//  WatchListView.swift
//  Project
//
//  Created by Malik on 24/05/2023.
//

import SwiftUI

struct WatchListView: View {
    @ObservedObject private var watchlistManager = WatchlistManager.shared

    var body: some View {
        NavigationView {
            Group {
                if watchlistManager.getBookmarkedMovies().isEmpty {
                    VStack {
                        Image("empty")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .padding(.bottom, 20)
                        Text("There are no movies in your watchlist")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.bottom)
                        Text("Try adding some by clicking the bookmark icon")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.bottom)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(red: 0.14, green: 0.16, blue: 0.20))
                } else {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(watchlistManager.getBookmarkedMovies(), id: \.id) { movie in
                                NavigationLink(destination: MovieDetailView(viewModel: .init(movieID: "\(movie.id)"))) {
                                    VStack(alignment: .leading) {
                                        MovieListView(movie: movie)
                                    }
                                    .padding(.horizontal)
                                    .background(Color(red: 0.14, green: 0.16, blue: 0.20))
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(radius: 5)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .background(Color(red: 0.14, green: 0.16, blue: 0.20))
            .navigationBarTitle("Watchlist", displayMode: .inline)
            .onAppear {
                watchlistManager.objectWillChange.send()
            }
        }
    }
}

struct WatchListView_Previews: PreviewProvider {
    static var previews: some View {
        WatchListView()
    }
}
