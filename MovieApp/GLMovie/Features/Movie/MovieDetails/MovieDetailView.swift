//
//  MovieDetail.swift
//  Project
//
//  Created by Malik on 25/05/2023.
//

import SwiftUI

struct MovieDetailView: View {
    @StateObject private var watchlistManager = WatchlistManager.shared
    @State private var selectedTab = 0
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: MovieViewModel

    init(viewModel: MovieViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(Color(red: 0.14, green: 0.16, blue: 0.20))
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        ScrollView {
            VStack {
                if let backdropURL = viewModel.movie?.backdropURL {
                    BackgroundImage(url: backdropURL)
                } else {
                    Image("defaultPoster")
                        .resizable()
                        .frame(width: 95, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 10)
                }
            }
            VStack(alignment: .leading) {
                HStack {
                    if let posterURL = viewModel.movie?.posterURL {
                        CircleImage(url: posterURL)
                            .offset(x: 20, y: -90)
                            .padding(.bottom, -130)
                            .padding(.horizontal, 30)
                    } else {
                        Image("defaultPoster")
                            .resizable()
                            .frame(width: 95, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 10)
                    }
                    Text(viewModel.title)
                        .font(.title)
                        .foregroundColor(.white)
                }
                .padding(.bottom, 40)
                Spacer()
                HStack {
                    Label(viewModel.runtime, systemImage: "clock")
                        .foregroundColor(.white)
                        .font(.custom("Poppins", size: 16))
                    Spacer()
                    Label(viewModel.released, systemImage: "calendar")
                        .foregroundColor(.white)
                        .font(.custom("Poppins", size: 16))
                    Spacer()
                    Label("Action", systemImage: "ticket")
                        .foregroundColor(.white)
                        .font(.custom("Poppins", size: 16))
                }
                .padding(.horizontal, 20)
                Divider()
                // Tab bar - change to match figma
                DetailTabsView(selectedTab: $selectedTab)
                    .padding(.horizontal, 30)
                switch selectedTab {
                case 0:
                    if let overview = viewModel.movie?.overview {
                        AboutMovieView(description: overview)
                            .padding(.top, 10)
                    } else {
                        AboutMovieView(description: "movie description not found")
                    }
                case 1:
                    if let id = viewModel.movie?.id {
                        ReviewsView(viewModel: .init(movieID: id))
                            .padding(.top, 10)
                    } else {
                        ReviewsView(viewModel: .init(movieID: 550))
                    }
                case 2:
                    if let id = viewModel.movie?.id {
                        CastView(viewModel: .init(movieID: id))
                    } else {
                        CastView(viewModel: .init(movieID: 550))
                    }
                default:
                    EmptyView()
                }
            }
            .padding()
            .onAppear {
                viewModel.fetchMovie()
            }
            .background(Color(red: 0.14, green: 0.16, blue: 0.20))
            .foregroundColor(.white)
            .navigationBarTitle(viewModel.title, displayMode: .inline)
            .navigationBarItems(trailing: bookmarkButton)
        }
        .background(Color(red: 0.14, green: 0.16, blue: 0.20))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .refreshable {
            viewModel.fetchMovie()
        }
        .onAppear {
            UIRefreshControl.appearance().tintColor = UIColor.white
        }
    }

    private var bookmarkButton: some View {
        Button {
            if let movie = viewModel.movie {
                if watchlistManager.isMovieBookmarked(movie) {
                    watchlistManager.unbookmarkMovie(movie)
                } else {
                    watchlistManager.bookmarkMovie(movie)
                }
            }
        } label: {
            if let movie = viewModel.movie {
                Image(systemName: watchlistManager.isMovieBookmarked(movie) ? "bookmark.fill" : "bookmark")
                    .font(.title)
            }
        }
    }
}

struct MovieDetail_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(viewModel: .init(movieID: "550"))
    }
}
