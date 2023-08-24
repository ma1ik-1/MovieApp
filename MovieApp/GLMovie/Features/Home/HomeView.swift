//
//  HomeView.swift
//  Project
//
//  Created by Malik on 24/05/2023.
//

import SwiftUI
import StyleKit

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel = .init()
    @State private var isSearchBarClicked = false
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            ZStack {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                case .response:
                    ScrollView {
                        contentView
                    }
                    .refreshable {
                        viewModel.fetchMovies()
                    }
                    .onAppear {
                        UIRefreshControl.appearance().tintColor = UIColor.white
                    }
                case .error(let error):
                    Text(error.localizedDescription)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.brandBackground)
            .onAppear {
                if viewModel.needLoad {
                    viewModel.fetchMovies()
                }
            }
        }
    }

    private var contentView: some View {
        VStack(spacing: 20) {
            NavigationLink(destination: SearchView(), isActive: $isSearchBarClicked) {
                EmptyView()
            }
            .hidden()
            .frame(width: 0, height: 0)
            SearchBarView(searchText: $searchText, searchAction: { _ in })
                .onTapGesture {
                    isSearchBarClicked = true
                }
            MoviePosterView(movies: viewModel.popularMovies)
                .padding(.horizontal)
            MovieTabsView()
                .environmentObject(viewModel)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
