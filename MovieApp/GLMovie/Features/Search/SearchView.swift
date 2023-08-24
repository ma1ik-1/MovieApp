//
//  SearchView.swift
//  GLMovie
//
//  Created by Wei Lu on 21/06/2023.
//

import SwiftUI
import Combine

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @StateObject private var watchlistManager = WatchlistManager.shared

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                SearchBarView(searchText: $viewModel.searchText, searchAction: { query in
                    viewModel.searchMovies(query: query)
                })
                .padding(.top, 8)
                .padding(.bottom, 20)
                Spacer()
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        if viewModel.searchResult.isEmpty {
                            if viewModel.searchText.isEmpty {
                                SearchSplashView(index: 0)
                                    .offset(y: 60)
                            } else {
                                SearchSplashView(index: 1)
                                    .offset(y: 60)
                            }
                        } else {
                            ForEach(viewModel.searchResult) { movie in
                                NavigationLink(destination: MovieDetailView(viewModel: .init(movieID: "\(movie.id)"))) {
                                    HStack {
                                        MovieListView(movie: movie)
                                        Spacer()
                                        if watchlistManager.isMovieBookmarked(movie) {
                                            Image(systemName: "bookmark.fill")
                                                .font(.system(size: 24))
                                                .foregroundColor(.orange)
                                                .offset(x: -265, y: -55)
                                        }
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.clear, lineWidth: 1)
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .refreshable {
                    viewModel.searchMovies(query: viewModel.searchText)
                }
                .onAppear {
                    UIRefreshControl.appearance().tintColor = UIColor.white
                }
            }
            .background(Color(red: 0.14, green: 0.16, blue: 0.20))
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
